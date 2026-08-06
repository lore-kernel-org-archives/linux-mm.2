Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03AEFC56205
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 18:58:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9F446B00A5; Thu,  6 Aug 2026 14:58:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4ED76B00A6; Thu,  6 Aug 2026 14:58:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D17956B00A7; Thu,  6 Aug 2026 14:58:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9E8666B00A5
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 14:58:22 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CA453801D0
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 18:58:20 +0000 (UTC)
X-FDA: 85071755160.14.AB238D7
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf27.hostedemail.com (Postfix) with ESMTP id ED15240008
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 18:58:17 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=HUXP8HtD;
	spf=pass (imf27.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786042698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E4r/Kz62Dp3MnNegLcstylRZKtOlPDdEQUeD76T1NRw=;
	b=qtdYgSeNSy8U8R0D0SW4JqdS1EES9GHzH9/XmqXfXyv+t99ISV9W0L9Bf76izLDnT00Gkg
	Usa6lmjwUm880SZbpnXcb+14IbJVGyqjPrRsGt99R2ChObsQgwc4nEFeibyYC15vNCPC3h
	w5FboyqUkEsA3mECwiJt2q2QDPfLNHA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=HUXP8HtD;
	spf=pass (imf27.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786042698;
	b=n7WxdQZnQqW4cb3KfNw2CWM9M4GUD5Hfq7hkOlEuYYoIzafa3mmLoHeFanC70H4ZajtCzw
	leJNldn7R4fFITf4xxZipmDw46o2zbkVvFwEMrL2A9P4wDsSNOZoMfolcSkRU+CZWtc0Rn
	anYKHvOM1KKETOt4J6Csa9M1C1tUlQo=
Received: from pps.filterd (m0167072.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 676IYX8R4165205
	for <linux-mm@kvack.org>; Thu, 6 Aug 2026 14:58:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=E4r/
	Kz62Dp3MnNegLcstylRZKtOlPDdEQUeD76T1NRw=; b=HUXP8HtD2W9xKBV9xfAr
	9LPpNCOEQJgXhH8rxQCaGu/K+rhFN0xajLHugIRl/cQmDxmd+NM9Zmo7q2X4PiGb
	Nwruq6hDE7L8gZeMrmu2ayb7U9IElIGtm7txA/vhPkW87XOwPS79xQuVdK2gusVm
	8TC5+tOqLKk45W1QeYkHYntfLL9kIquuGBFLscxcCSkQWbXv6sg2TrKUrX8RlZW+
	S9QHqB1IuYIyD3lQZYwJqpk05xIVAMJSXb5fXDr1hfTG47yp0ay4KOfHjJel3ZvX
	GYl0kuWf2gM1eucIRZZmEVCLFRV9IosDOZ/IuZ6XSQXtMD2G9pE4nJ8XrySm72Ni
	QQ==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4fvy2y8f2c-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Thu, 06 Aug 2026 14:58:16 -0400 (EDT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-51c1a9764f0so26636891cf.1
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 11:58:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786042695; x=1786647495;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=E4r/Kz62Dp3MnNegLcstylRZKtOlPDdEQUeD76T1NRw=;
        b=Qz6Zre1/DYc7xnGDxrKEqJCk5J9pX+Ga4Q9w4m2EAFXucjfdYev3pJb15qid5eavJi
         D+jDIVXktMP7hFHRKUMYAMa3Vp+jzzNWXmA5+SFXg5L/TbO0BLWkwFN+eMtos9BPqqU+
         FsGsrqGOrcBbMujfCX2CyzbNeMOcfSlx6udLRpTZ4Cvk+VsIlo4AcdkzqZiY6cSi2o+9
         0ADxzjVmoCcUMvP68/ETu/Nz/g25Wbe/2PcxKZbxzA6QjGU0Ek2qOkwTcg76m8vmSlxK
         pLE0V+4yUlJmbgFlU9daD1N4wXIwMg9PP9+/mffav3TzxidCcTQuC9A8e44+tNjzlUFg
         ohJg==
X-Forwarded-Encrypted: i=1; AHgh+Rp4MudUu2SaqB4sLoJUqjvDevchpAMRAw7sVDN99n7u9UpIdIbm4vruWIhfaG1KXdmHn1evHLrRKA==@kvack.org
X-Gm-Message-State: AOJu0YxK/amMnOvTBOVS+vbXQieiANTLZ3nLj2DKC1W3yDAf1YqHs0Ky
	2NtlDs6EyryQ+H62g2UfohvWYwd5LRu3FtBM6d7EE5iLtDUkjHCaY/AQTDbfmqgHGHAQOtOIzgw
	yTdV9S6WewEtMyDFclrmhn78Ff0XBij2W6XERqj7MbIG4cuid
X-Gm-Gg: AR+sD11i7CVWttmENHup4H4TFNCFZxEZUAwAtIRlAomcPYFVtnbyldb30wJEUJs0zIz
	voHdoJilkgxerH3SLJLTah32f/p2h84toBf5kVQKeqmnQS2fcdNH9SZd1xNudKVBYRjJviy66S8
	6grmf73y7qMzjKNA5BaeUEV47KgfbLdue+zfzMb3Uu/hVhQ1gkp7WTOkUR2hKMKzUyVoDEuY3XG
	r7rY40oIabwLq+dgYzm1CC4PpnttmQ7MKcBje/Ds6HHO133UY3590qKisCL1nH4VoUD6hvoBPX/
	Qe5jOtyeCZfon4rMk60WEHrkBKFCoSgcFAuKNwW3d6BcKUDJXRdtNqH6eIZvOTXx7AMvvQmAy1Z
	Fh22A/0d3+MNC3Q3aQDHOSccUSNdKbLL9ncUkJKBc3TSZWZURv+rANJlSNtH58Ex4
X-Received: by 2002:a05:622a:8893:b0:51c:f8f:13d with SMTP id d75a77b69052e-52ce61bd900mr186870391cf.37.1786042695460;
        Thu, 06 Aug 2026 11:58:15 -0700 (PDT)
X-Received: by 2002:a05:622a:8893:b0:51c:f8f:13d with SMTP id d75a77b69052e-52ce61bd900mr186869731cf.37.1786042694934;
        Thu, 06 Aug 2026 11:58:14 -0700 (PDT)
Received: from ?IPV6:2a00:a040:199:782e:b593:3821:1a47:8a5e? ([2a00:a040:199:782e:b593:3821:1a47:8a5e])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4995bb88b41sm7274825e9.0.2026.08.06.11.58.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2026 11:58:13 -0700 (PDT)
Message-ID: <f835fc25-7841-47ff-bb2a-7f91b534dec1@columbia.edu>
Date: Thu, 6 Aug 2026 21:58:11 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/10] ceph: convert ceph_submit_write() to folios
To: Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>,
        Viacheslav Dubeyko <slava@dubeyko.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Zi Yan <ziy@nvidia.com>
Cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <20260804-remove-wait-on-page-writeback-v2-0-81f0ab065284@columbia.edu>
 <20260804-remove-wait-on-page-writeback-v2-5-81f0ab065284@columbia.edu>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <20260804-remove-wait-on-page-writeback-v2-5-81f0ab065284@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=VfHH+lp9 c=1 sm=1 tr=0 ts=6a74d948 cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Da8U98TiO7q1upZEImrf:22 a=SsB-OO3BMngHh3ZO9fOt:22 a=5poVChmWhSypMT2yhmcA:9
 a=QEXdDO2ut3YA:10 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-ORIG-GUID: 7DdePCGzhwQOJhDgf7xzN9tejLDrVOSe
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDE0OCBTYWx0ZWRfXwsq9fWqQbnP4
 F4VZEomYL+VEb5D5zuhDLlw/DhZWmdnhhIaHJ8PCGRcAyaQMK4kIgn0g0nd0B9iaxK237dtb3nA
 GRfA07vhQHVGJLtQ6veTDBLg2dKTAfwtYyH0POpMhfIo8wcNMTHq
X-Proofpoint-GUID: 7DdePCGzhwQOJhDgf7xzN9tejLDrVOSe
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDE0OCBTYWx0ZWRfX65hmmwCXe7ui
 Z1Z7R8ter+QRfKrgqnHKJJRxX8k4gUtEGT3s9njlnWkuRKF0LCN/mFsEJ5bcbuD4hZ0VGYtmQd0
 MHQ2x0V82D9lprhG5Zng8PymEdkXn+v9BAimM4f16EVQ4arRE0fYZ9KxnaQPY1kQNIAXKCNsRcL
 CXtgNFPtloB1VlBYarLxleC5uXLCSNH5h0zUFogpVvr5HZxCIRkNDWTSwcDz5v6+/gmGSPeiZzX
 Tq9/goeOZQljG1ITLx+DfD3kz2HXiuvQodIqfqNcOXXCqB5ezj05hVMjN7ZwnnFzP9SUt41/rsT
 ooKJPDYPNxkZs1Q6ifOgqz9o9QabV5w4ZIHMWXtt2j0+xUTD79f99qAvQ+IKc5EgJeJEoOKmqnd
 K0mC0ncrbzrpERecKwJbQbyQFY0tl1rFcWlXYc36yarAAg4rI0T6SEvxH0oevleug/YrRuxqjhN
 I2XWjeajnaEuom0Mxdw==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11867
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1015 spamscore=0 malwarescore=0 phishscore=0
 impostorscore=10 bulkscore=10 suspectscore=0 adultscore=0 lowpriorityscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608060148
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: ED15240008
X-Stat-Signature: qtkun94t6e5rgrdggr1xd7tucxtdi1xr
X-HE-Tag: 1786042697-480778
X-HE-Meta: U2FsdGVkX1/65mz4tB9DPJPYBzbQa70n4kgvXsASztU3E0jDseJcf+ki2vIh/+qenqfJ/BnlvqP9uOnaRJgox/kh1GpNwyA4LaOZjgVNelKTccue2L9vosukP8g8cog0Ld+2TjjWPwym5AI9753VhiqHcTk7ZKahBrUMPskC6ElZORhju9OXFjTMenXCq7/dqqHCACFU8dN1BqqcTTbER3xngoyO5cfbfEhWEg1GtnwtEcDdxOuwx8GR1kUt9map4vS7EgfSk3PbfB329QhVgfOTVfM50e04UZZSQNAuuAVDIG/Vsf1uxAXm89oNruWQilqEmLQc2iH24GxSfT30kSuKBxV0UMCuxNzJa6UeUYvcRbTJn+LtYVwRsbrrqtPpx+lu1WApBh2T30i1wsdWHVz/WScHDvgjZTY3ZTxqvY0uPPam4j+V9Duhojup5J0UJKAm48jQM7cUr2Zt9hMldQQSPC9M1nOHukJHtsWPvEHip/Ya9HsdXi0rAiS4QFVB2LPbBly6IuSSVMF5kw5Kyyi5uYtoh/kZR7TK8mgCa93MhVpAovUKe74LGueYJtTdVVnY7lVwnTba46o+YiXEFrs881EjoZiTFtNhjeRWfg/iX8WNmTRw+R6EyKnpTEKvUPnjTJsNRq5QA4N0xzRvre3A0N8kMUq1VRj2Rwj/fcOd/kf2cLLV8K61jAXSTQFh/P5NSe8mpILTQ+XCQa3UBWhwDgQOhKFKA2Dnr4QR/xPVhthjgn9IjLwbIvPayqI2s0RITqGzwzdb5eRU9kUT4m/TVKpKfSOWXtGVEjRuk+0xxXOc83UADMrr3YPa2ESae9ioXitupMoScqMwbMA6p/FN/j4BNVNy8o0RK2LDM4CvUwi0+Y3zHHsQKKwh7k4Gf/KccJF8wDGLn4qyRZqb8r4UPj/kwLhuhGT308IZGC4rtMGXCeAn37e6+b2pdKn9OzUiC7nqfpxzbUL+udn
 5McKMGD4
 q2TsssigG9WSAbU0lV9ztAJcg8ecX5facJjK1TvwouMZff1L6Irg5djxlZdHmzW43FVYsJiox+uKU4jRFXjD809bE1J7sTBVAURhzUjB6PjjvM4TM4w+MZQL1X9efhT1ZKIsS+MsGTRIAYs5TRKIwrxWWK5/AEAKtA1EBZLtWELNioldFAA3b/OGz80RYdxeS9wZUh7Zct7Bv+EAKQ/C0OoZ+dUIckIeg4C8EPXhu+sLyIOQXy/DVmHZJg6THaJYRIusOIeZczXNu0GV0l/UnDjf6E71KpxkqYDXzgrLCjOJ7ZZKXEqhE3RoQRwykqZo+/AfqiVpxRHmrlWXC+0u3zX4OXYDNElaFWUPVZE+Jg9XLnBlQQUgKU6ZsMMk8RsIicgqqB165k2qi8Gs8Ud7ivqAtDK4n5EjaZFVvQOu2aE+L0q7wCRwrVNNKRrix0vK8f9OBBscWLq+ssJEXc70k/O3TyXl3iL9Wickf8oggu8JscR9haNTU70YQM4WW211UX8XcQF5DOgWRFcY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/4/26 2:52 PM, Tal Zussman wrote:
> Convert the request assembly loop and error paths in ceph_submit_write()
> to folios. This drops ceph's uses of the set_page_writeback(),
> redirty_page_for_writepage(), and unlock_page() compatibility wrappers
> in the writeback submission path.
> 
> Add ceph_folio_start_fscache(), a folio counterpart of
> ceph_set_page_fscache(). The remaining caller of the latter in
> write_folio_nounlock() will be converted separately.
> 
> In total, this removes nine calls to compound_head() hidden in the
> page-based APIs, while adding four explicit ones via page_folio().
> 
> Note that get_writepages_data_length() must still be passed the
> possibly-bounce folio, not the unwrapped pagecache folio, as it checks
> fscrypt_is_bounce_folio() to round encrypted lengths up to the fscrypt
> block size.
> 
> No functional change.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---
>  fs/ceph/addr.c | 44 ++++++++++++++++++++++++++------------------
>  1 file changed, 26 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index c81e9da42df9..a96986c503bf 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -553,6 +553,11 @@ const struct netfs_request_ops ceph_netfs_ops = {
>  };
>  
>  #ifdef CONFIG_CEPH_FSCACHE
> +static void ceph_folio_start_fscache(struct folio *folio)
> +{
> +	folio_start_private_2(folio); /* [DEPRECATED] */
> +}
> +
>  static void ceph_set_page_fscache(struct page *page)
>  {
>  	folio_start_private_2(page_folio(page)); /* [DEPRECATED] */
> @@ -575,6 +580,10 @@ static void ceph_fscache_write_to_cache(struct inode *inode, u64 off, u64 len, b
>  			       ceph_fscache_write_terminated, inode, true, caching);
>  }
>  #else
> +static inline void ceph_folio_start_fscache(struct folio *folio)
> +{
> +}
> +
>  static inline void ceph_set_page_fscache(struct page *page)
>  {
>  }
> @@ -1436,14 +1445,14 @@ int ceph_submit_write(struct address_space *mapping,
>  	struct ceph_client *cl = fsc->client;
>  	struct ceph_vino vino = ceph_vino(inode);
>  	struct ceph_osd_request *req = NULL;
> -	struct page *page = NULL;
> +	struct folio *folio = NULL;
>  	bool caching = ceph_is_cache_enabled(inode);
>  	u64 offset;
>  	u64 len;
>  	unsigned i;
>  
>  new_request:
> -	offset = ceph_fscrypt_page_offset(ceph_wbc->pages[0]);
> +	offset = ceph_fscrypt_folio_offset(page_folio(ceph_wbc->pages[0]));
>  	len = ceph_wbc->wsize;
>  
>  	req = ceph_osdc_new_request(&fsc->client->osdc,
> @@ -1467,29 +1476,28 @@ int ceph_submit_write(struct address_space *mapping,
>  		BUG_ON(IS_ERR(req));
>  	}
>  
> -	page = ceph_wbc->pages[ceph_wbc->locked_pages - 1];
> -	BUG_ON(len < ceph_fscrypt_page_offset(page) + thp_size(page) - offset);
> +	folio = page_folio(ceph_wbc->pages[ceph_wbc->locked_pages - 1]);
> +	BUG_ON(len < ceph_fscrypt_folio_offset(folio) + folio_size(folio) - offset);
>  
>  	if (!ceph_inc_osd_stopping_blocker(fsc->mdsc)) {
>  		for (i = 0; i < folio_batch_count(&ceph_wbc->fbatch); i++) {
> -			struct folio *folio = ceph_wbc->fbatch.folios[i];
> +			folio = ceph_wbc->fbatch.folios[i];
>  
>  			if (!folio)
>  				continue;

This, ...

>  
> -			page = &folio->page;
> -			redirty_page_for_writepage(wbc, page);
> -			unlock_page(page);
> +			folio_redirty_for_writepage(wbc, folio);
> +			folio_unlock(folio);
>  		}
>  
>  		for (i = 0; i < ceph_wbc->locked_pages; i++) {
> -			page = ceph_fscrypt_pagecache_page(ceph_wbc->pages[i]);
> +			folio = ceph_fscrypt_pagecache_folio(page_folio(ceph_wbc->pages[i]));
>  
> -			if (!page)
> +			if (!folio)
>  				continue;
>  

... and this check are unnecessary. ceph_fscrypt_pagecache_page() can't
take or return NULL, and ceph_shift_unused_folios_left() compacts NULLs
out of ceph_wbc->fbatch. Will remove both in v3.

> -			redirty_page_for_writepage(wbc, page);
> -			unlock_page(page);
> +			folio_redirty_for_writepage(wbc, folio);
> +			folio_unlock(folio);
>  		}
>  
>  		ceph_osdc_put_request(req);
> @@ -1506,8 +1514,8 @@ int ceph_submit_write(struct address_space *mapping,
>  	for (i = 0; i < ceph_wbc->locked_pages; i++) {
>  		u64 cur_offset;
>  
> -		page = ceph_fscrypt_pagecache_page(ceph_wbc->pages[i]);
> -		cur_offset = page_offset(page);
> +		folio = ceph_fscrypt_pagecache_folio(page_folio(ceph_wbc->pages[i]));
> +		cur_offset = folio_pos(folio);
>  
>  		/*
>  		 * Discontinuity in page range? Ceph can handle that by just passing
> @@ -1540,12 +1548,12 @@ int ceph_submit_write(struct address_space *mapping,
>  			ceph_wbc->op_idx++;
>  		}
>  
> -		set_page_writeback(page);
> +		folio_start_writeback(folio);
>  
>  		if (caching)
> -			ceph_set_page_fscache(page);
> +			ceph_folio_start_fscache(folio);
>  
> -		len += thp_size(page);
> +		len += folio_size(folio);
>  	}
>  
>  	ceph_fscache_write_to_cache(inode, offset, len, caching);
> @@ -1556,7 +1564,7 @@ int ceph_submit_write(struct address_space *mapping,
>  		/* writepages_finish() clears writeback pages
>  		 * according to the data length, so make sure
>  		 * data length covers all locked pages */
> -		u64 min_len = len + 1 - thp_size(page);
> +		u64 min_len = len + 1 - folio_size(folio);
>  		len = get_writepages_data_length(inode,
>  						 page_folio(ceph_wbc->pages[i - 1]),
>  						 offset);
> 


