Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B343ED711CC
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 23:39:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 257EA6B008A; Thu, 18 Dec 2025 18:39:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 225AA6B008C; Thu, 18 Dec 2025 18:39:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 152B26B0092; Thu, 18 Dec 2025 18:39:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0212F6B008A
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 18:39:33 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 94755B87CD
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 23:39:33 +0000 (UTC)
X-FDA: 84234211026.29.A973859
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf04.hostedemail.com (Postfix) with ESMTP id C590B40007
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 23:39:31 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Fr+sggop;
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.173 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766101171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vfMBm1bDNbFAwm3WT8c4tlLLumNOPMrsPhFihcCUs8I=;
	b=wHlO2ThgZExKmTKiyIUkG8Vi5LnkS6jWMI12YEsl8wqm0FH6ljW2LoXZHkiKgJeS+rI4fR
	mJyh/7ji2d6FyIN4m6qksoBc+ZE0Wmg+uoYPXZ+93VfwD8fZkV2LmQ7I0MAXfvKSB24nyg
	uDO6SWExOmM0yPO3v/eV8nQgcT32JXI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Fr+sggop;
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.173 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766101171; a=rsa-sha256;
	cv=none;
	b=Jvwg/bfkpJNDhc2fFdl7r9++/gnwwBdwwf+HC8Z7lIcUf2QqMfI4aDmBrzhYiiEA1CtdXz
	3PtbH7rhlCtpurcnoHuY/rcS2n3t63pfMkFrJ87H5yOEsb6lQfKpQVoZHa3lxr4GcIHXqn
	AxrmN7TqJBvhgMmBFvZQd1oeS6lCPBo=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4eddfb8c7f5so10720941cf.1
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 15:39:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1766101171; x=1766705971; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vfMBm1bDNbFAwm3WT8c4tlLLumNOPMrsPhFihcCUs8I=;
        b=Fr+sggopi+eTlD6QleFo3KHhWVk1ySdsj+mEnbpnUrj2JAb3CTjlYihbgxojnQPqn4
         ZFPutePove3PCPQ8AzsJUh7ytl9bEAuoPF3b9t8koGlWw7gD2CZHQjNTL/CGc/zByk2x
         Xwcdh5Pl/NJlkwjqA4p27Ev725fieurcKXj8jfKBg3UHlG78UqcwB0HxPKlbcOkryu/B
         ifHIGXVw1rnlUqL0Tyddhh/pZRwocacG1n8jGjlqUejoIpZY8Jjf7DW2LXHgnaRW7A0C
         QbTeQCCZfhQgmXomGxEtC9sRATBiQu4ewZkYQ1UcM8Yw4671rRcY4Zm02gZhLfsrja56
         5F8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766101171; x=1766705971;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vfMBm1bDNbFAwm3WT8c4tlLLumNOPMrsPhFihcCUs8I=;
        b=Pvrjwabb4jj0gVl4diJdADqcyNEM56uK5o8NHfNpWlRGNmICAdK2NbCxO6FBiClYDT
         r12k4DRhcwn9htVCjrOx4zRSJtDUZhiw6iIXppLfLrmXGSHUCaWTFt368evo/q2AK8yr
         AnvTMUK9G64J0lJl7dcTCR89/wiUNa/ZlJR3w2JKXR99E8FwBt5AlfFoK4SG5uNi2o26
         VDZqbSbpe1BDGvdC134+8nAXQVRBLXBvFa7xulu1vjUQY+0dfovIR7OutG5yjh7nlyje
         FzFTNtrOpGwq4MGbQjXkaS+PevlrYndrF28KgvTc5abgJMOfabMLcetVexHKnwDXiudC
         JIog==
X-Gm-Message-State: AOJu0YwBD9eAKL8LeT1OcH1E7l3pvZAzS8zJHyz+psreWVMGYHOcER7c
	rr4cT2AqloiLTHDiQMrL6dkqDEcE8TERYuHPsUwFFKD9ln3p/5nsiqlSfsagNQsArKg=
X-Gm-Gg: AY/fxX5OcY6Uesy72iHWdGKyf6iJRn5FkVCGOp7TrPj2owWeiTlMs0fzI1Cfb7YogZl
	RhkgKGSyqyYBy86iK3uHc/sND4WaB25d7/kuo72aADQTZjIPl3kzEJCBj/m6IDuDftuoWN/g74G
	F+Htu0aWZvd5FQAMkobPax7LOad6zPn2TfgrzqUHJiB9HJNipgHLtT4zgdL/F7C6OUiLjqCk30J
	WIhQd71FLudamqPh8FOVM/chxAGKUVMazl2CFVpwq09cGZYFBITnb6X2dw+YQy0RyxzNQC/fxF0
	S7Ey3nCtyoBDwahmWr1BJ6spAu9MyqeiBsPl75pyI62ZxZY9fYW3djnX7FcwzNKnfLt/LQh9Sqf
	hN9iax2O+skxEHCGB7B00DfSfzHZNy0FBeV26hMVNPUnY3LClNRsZ4BJ1xlesULvvn4QW1rO6a2
	bGKl9dbO5Z3KlB8QWl1/1A951OJc3QJBIeEmt5kHtF8SAN1OIVQyF3wuUnRp72VsmXpJDaFQ==
X-Google-Smtp-Source: AGHT+IHQ2+KLAll0R1evRZxttbrE+64n/VEexDqsHoPCtzztWRFPS/milNcI9OQhx0kQ6IJeg05Uxw==
X-Received: by 2002:ac8:5fc4:0:b0:4f1:ba0d:69a0 with SMTP id d75a77b69052e-4f4abccef51mr15467371cf.15.1766101170942;
        Thu, 18 Dec 2025 15:39:30 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c0970f5fcdsm52571485a.29.2025.12.18.15.39.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 15:39:28 -0800 (PST)
Date: Thu, 18 Dec 2025 18:38:50 -0500
From: Gregory Price <gourry@gourry.net>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, jackmanb@google.com, ziy@nvidia.com,
	richard.weiyang@gmail.com, osalvador@suse.de, rientjes@google.com,
	david@redhat.com, joshua.hahnjy@gmail.com, fvdl@google.com
Subject: Re: [PATCH v5] page_alloc: allow migration of smaller hugepages
 during contig_alloc
Message-ID: <aUSQin8iN78L9gKU@gourry-fedora-PF4VCD3F>
References: <20251218190832.1319797-1-gourry@gourry.net>
 <aURXd7d1on5vxnnT@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aURXd7d1on5vxnnT@cmpxchg.org>
X-Rspamd-Server: rspam02
X-Stat-Signature: 5c5jgps4pndrkfq7howsf4jwt5bohxpo
X-Rspam-User: 
X-Rspamd-Queue-Id: C590B40007
X-HE-Tag: 1766101171-573432
X-HE-Meta: U2FsdGVkX1/wlF8Pi9uAM0AbuQgGdlS6dK8sVuQusrg9SkjXKDtez0Cv5RMju/xz5zAPC514ObySpxg4/YqYOQKlfNHD+1CV7hN0ANPCM2IxekshgBtzpcHSEb6gaWw1Wm641lEQUfkuspTkEwz+d1uPkUxJ8lrvj5LA6B8cKZHlpm2NUhmqXb56Dd5m7WN+MGih4ZEdf4M7WqBk7BQuVuryOPW3WN3eNd5nEVgtCY/TJVSCKRHPKKnS6oNxDbB795E8AJsvrzRt43FCSw3P/DicabVrGTTqmYoqHKIiYUn/kRUIgb5OWqYU56URCOTsfQ2nWby2lVU1kJ8Iaof5DbcG0vOXFeslmqVpp90Qtiiyk+pdY5G3UIBRVJzm6yPW7Etc6xw2yMQejEukvLoILWcq2j50QnSid4SyZ/EYxv3uzvZr607DkrlBqqCC7OyjDHkeR3o/AbGa4Hd/JlqTtgx17Aj5nVAO3maNEbfMukzPR+k4pSgJHycf4/YgyBhl9QPP1bh9u+BQ1molkxqL3Lnq9uQeGUv6i+n1Bol+aWlawn1oxWr8QT1iyoLOT8rsY3mJseZpuwhorh2dTg6AEUvGGfM0lj1Hse6PTAR4rE7bglhu361W4fi08nmFXek73GhTOahcJiYDxCCU+9R0yr6H3wrDyQzNZ+9aMbO3uVsRUtrSfWB7UZwR7BGMD/ZOolKYT0uOw3Ls3oWb57mGZTTkbmvF6R+Po6/g1BaIxdINMcFnFOhSE+3vqEzpV0emQl+jyJjTR2/gTikmzY0BAK2Lpyx4LxC0QRRVIr+jVF2fBN6AICT7fAb4XBigi4Erg7qJfoibCmVPobBOii3YSSf9s3g9IAft4+riqtfC0Uwwz3s3IRtdCS+pZBFHltco8oEnjvaIqTkjC6PLFzK9j2GREDjyOWafFZBOfLdGS7Q5EYzKwJt9QDPPzNBn6KYN2eCpqVTIG0sHXgs+UK4
 cRVu+fjU
 QY3g3i2d+J6ERuagXD+XcEF+Goe/OxjgfTQKDlKoyIE0RDWUpLW4Gx9fuNbuQHaD0JyoAm+p6KEMnF6JmS1tfj6H9Z5I/Vkw1cgTIX3gLrhtYyVhnAwR0N6NAdcjm3Ifat2ORyCAE2OxUIUczerG8VkPoXBDt9nVwdI2o2bObWA7IsbiDjRm7tmd8C+V9PycCTuW0Rnaoat9VIItVUa5q1r19tq5e78B8eQHwVt40+X1C/jDGMQ2YglADKIA+Tw/TAgdym/E5W+6RoaF190mCxF8wT+Mb3oQNCu329CXa03PedUM1xevu3ykhbkgdEIppKVaKX/eKDKbmdkv21LvOJKv6I/YN6lnmwFnef5Pf5i2EDcy3XrTyNbqL1LDVWOuvbyG1/mUf+Sa0zh0yO/5ezYycHOxrxFrIMLWCAjfrJbjT8fG32WFltFjFR9xbQ8S10Qyx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 18, 2025 at 02:35:19PM -0500, Johannes Weiner wrote:
> On Thu, Dec 18, 2025 at 02:08:31PM -0500, Gregory Price wrote:
> > +			page = compound_head(page);
> > +			order = compound_order(page);
> > +			if ((order >= MAX_FOLIO_ORDER) ||
> > +			    (nr_pages <= (1 << order)))
> > +				return false;
> 
> If you keep searching past it, you can step over the whole page to
> speed things up a bit:
> 
> 			i += (1 << order) - 1;

ack, good catch, added to v6

~Gregory

