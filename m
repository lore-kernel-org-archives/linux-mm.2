Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D901606A329
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 20:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=JLiSvhDY
Received: by kanga.kvack.org (Postfix)
	id 02BCD6B05B1; Tue,  3 Nov 2026 15:35:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1E6A6B05B2; Tue,  3 Nov 2026 15:35:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D709F6B05B3; Tue,  3 Nov 2026 15:35:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B048A6B05B1
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:35:12 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 41244A8144
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 20:35:12 +0000 (UTC)
X-FDA: 85394962464.14.DEA123F
Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com [209.85.221.170])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4787AC0005
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 20:35:10 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=JLiSvhDY;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793738110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+aadLIA3GPIeeFSZgpfHdaGRi1nlOlSeRKXWPRo2sBI=;
	b=bIytVYlWjIO/43Uv+CO4X915SpN6O/lrkp2UmKGqss8wAfE9VC9CRRQdfGsT1TQ6Lqhd82
	m46bpFzE5o5kb/vNpIfZx74h64pnY5fyBrm/KcGvQGe8k67jxrpf+j2FGKCxpyfhQ8rHob
	lRHmlnWyr0HWapE/VpujKxrQWipvUHM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=JLiSvhDY;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793738110;
	b=tfTV7KFKIA/+OvrnlAS27FhQNuaO0ydZn7pFgexAg+XE9X/cuGFDIhnLkIm1wMsCO1GtAE
	IN3/N0p/PaCjWEeZeLDHidsrMTjfcQ3IryaNL2vtJLRmK2z9usvYgrQt63l5CujJYP0yeB
	nwkhbt3OW8ON7lHfmOUQhhJVqw3QFDM=
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-5e9528732b4so3170538e0c.0
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 12:35:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1793738109; x=1794342909; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=+aadLIA3GPIeeFSZgpfHdaGRi1nlOlSeRKXWPRo2sBI=;
        b=JLiSvhDYGG3u0Xjlc5AdZrGqG1QhCzVXdfKEVGEQeyrQ1eAtNZBXUuoHGJiAn7p5OR
         QnuMUlvJgxIP6AgaQhLF0JGklMMX6faiQVXq5XrDku0kLAIo5/gXRhoWTCMO+vC04nAe
         9NCbXzrHXa75ZhWd4zntTr/vSNEmmZklXYjAPrfv3K9iru99259ESBoXGeKcVTqiDqKx
         s2KRap6GL5ars+xOB/qXsQX/yB8rW0S4p2sqeRiwb8joXft8L8RLpwuxXVn9LpyabWNs
         8sapZTlBcsAounTqatt/SvwUyaYYzHvNZ3ZN+ed9QMEjKVO7qPeREelXq17Flgg1uCIX
         RAWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793738109; x=1794342909;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+aadLIA3GPIeeFSZgpfHdaGRi1nlOlSeRKXWPRo2sBI=;
        b=E5y3UHlyoNHpqz/Euc6t+qbz4d7QcbmQtjKieqqS0FjfEi/ys3EIUgoHeL1SdwBwFQ
         q0Q1w1niOA9nl0+682fqKkiFY6pQru0gc38HAqdoj99xOdQQqmWnczeTnjAke0rGpbCc
         GAFmoYH+18XwDJl9K/zBQNPjNCVuZjIKaJNkruUN7LRKRAqU8DcHGufRxzwj7l1SRnM+
         sE47N6Nek+CSeTTfiQyZ2e0sqAN4oON1ZFlu0Wlo6qZvneal1FscTeQWJ7BnVLbCnC4j
         Tha/xn+OI0ljR76L43KaPdIYFft5QZPzKUPTpXe1CmK4plSuisOBrZYgxkWzpmYe1Y1k
         sMUA==
X-Forwarded-Encrypted: i=1; AKwUvBxKp3KWqXdTuJ8O7OQ2gi+8rXcHb8Q1eAjo8UmJHn/QE0fSKpoTbRS7I3yC9otR4tS6iE8YGxzDjA==@kvack.org
X-Gm-Message-State: APuU4Z/QXHHvibqGCIfb+z8G7M4UaqM38/CwaQrSDuLWw7aXikGymGnL
	kvV+pK8oWCBGHlC0US8dTH0UL4qW4hLQBUVUOmMMiyD33mli3NGHYt5sqOgXvuS3R74=
X-Gm-Gg: AYBFou0iU69h50s1dNrYjR07NNqYUevkU8xI7qVoEUy0VcmrUS4A9jQKCAcD7NnO0g3
	Hj0/TeInMbBjCEr3KvW0tIHDm8eyJmrsPYQv1z3ehs22DIHyNmPWnah1Ta3/DW6GZp1+FcjvqpD
	yH0/GEJHrHEtiAeb/QKoSAYu20wd1QPNuAuMB8w6vnHMgKiadP3Fkx9Ea6GnWCJcfH9oFJH05CE
	N3DH+sUh5fCTyX6MxiUkJJPxL48kEbKcZMya7QIX/d6v2fqvF82Z57lKLBzIUgXgR/La2M9b+vh
	VZkpS0Wkk/DsSLs6ccZA3ug9pHU96bo6Cm/oX0w4PJ/6ZEVU2yBTOIa/02pOz75ZRpPo5+/p65x
	R0NQ1GflmZ4zCmq6fIDIYqlaHph40hwC8trcvl44THA+Lb5ednHtu9DK0Zece6FxgHZk8rrNgTQ
	zfG4Kv2Tq5EaP/A7cSoLoaDGtmSLwNQhgopSjeiWyiP/8shtRP+S4ZNF7SAr1MLN083TRayXKoO
	DJNn6yvbLmro6mXNqrxsM38HmNzXzIgiIdxJEmFhmGCwCoG+SBDWdpz5KZC44zwATVAbOAQ7+1w
	fmxMiKUlwtQnGeY6OZFeB/6LVEh2LE9g6YJXoi1/AjNVX3WlWWhT2oWqDPGlUz6bsASKxHf7unB
	aCm9SIHKnDlMmcQDOJBq38aluzd2Qv/K/Q8suIP/wD+1wG6A=
X-Received: by 2002:a05:6102:fa0:b0:7b4:879c:bb76 with SMTP id ada2fe7eead31-7d072c45613mr6088445137.21.1793738109309;
        Tue, 03 Nov 2026 12:35:09 -0800 (PST)
Received: from soleen.c.googlers.com (64.167.245.35.bc.googleusercontent.com. [35.245.167.64])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-998d91d212bsm155984241.6.2026.11.03.12.35.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 12:35:08 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 2/2] mm/memfd_luo: keep memfd frozen until finish
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
 Samiullah Khawaja <skhawaja@google.com>, kexec@lists.infradead.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20261103181916.2462825-3-pratyush@kernel.org>
References: <20261103181916.2462825-1-pratyush@kernel.org>
 <20261103181916.2462825-3-pratyush@kernel.org>
Date: Tue, 03 Nov 2026 15:35:04 -0500
Message-Id: <179373810485.663454.3013535045194073890.b4-review@b4>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4103;
 i=pasha.tatashin@soleen.com; h=from:subject:message-id;
 bh=Q9ypSzsjws//mPEdnfoKVj2XLrGaTXlODYwHP6URKeI=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBq6kV7gzwYxzNrt8ME5QZOVfBKCFWD7TcrD+6Y8
 XNUBOCAUIGJAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCaupFewAKCRC7dyhM23N6
 3oOmD/45tsbGyvIfML7jhFB8SNoj9u0KhnedpAIpQwPtIW7BQkCU/VWLhvj6VtL0up9s07eAQb3
 X0G2UQD0u0r+KV3PffnvpmK3T7y+i2Q4vnJYb8UEeMuQBN4itfu+yFwFCxasz4skubWeoBcapZB
 JVHeuQL9rCZC+I8HL0SICEZCArUMYqWQ4gs5YLMwgb0+SI8TNTqIKuhgp+EL6mapJC2G7mp1l/d
 i80dMJBv4h0R+5nxX9TIKWZkDopl4CeHS6rNovT7htVgNiktIOAo/LvBiJ/Guag9NLwF+bdUk0K
 sKTTiGKm5Jcg5fkNhHrfwNdp+XAIb5Qx3OIGXfDy+4tH+as2CXTDIbR+cyXF7xVv0HCmxQL9hEE
 TEUdFej1A/CubkfpkVWuXldkQk1MngOiRcJ7saqYSjsNmJoN1FCYjLJHWMKCBlWbMeAlvgIbcf6
 P6lwko+CGQi1QvrDhK3v5TgKCkkdUJUsclABW64ciR/95j5dexoupov6Fmt4+kG+ZucpANvb5L+
 oZCOAUXQ2sqSRJHRv6qPK6ODHQ0GZIMoHBRqRA7Sq72ngSVaFqlTeAiNxfXN3q6LrT6pVnlaU9W
 v0+6Nd4cqgxNCJhp6rMst1eW+1nD+B71CoraCgtW4DCy79RDJIS6HmAdQjJTCRCJUKatPy0GwcM
 khpcHll+P8oHIEg==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp;
 fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4787AC0005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: 9o8e6mmjn8kh1sh5kjo5g6ui614gz1kn
X-HE-Tag: 1793738110-258090
X-HE-Meta: U2FsdGVkX1/Ob5O6Pxl/2vKPpv+7S9V+RrL5Si2PPQhP4qo+akfeE6NpEsYEDVq4cgWL3eBHB7B8rW797pkczSjztbHJYgrOdxsObSxEx+/8pt5gbGUrhhgObD4MTF0Exq9pvuTOcHwtCXvErG6PFzeL4HE1fxXFtQmtG86hAPE+rCoZY5/3lvdUQpmfA2QCQLDVaUS5zy2iJDE9fFTurhcdAL8I8ykRJuukrpG4CwjpflCkKt4Eiy4XZZT1I7I9OiqGgZPcrLeScWjlq3fXa53XstDGJ5xeqLKTaTID5VUZXNzoX0SFjQ6xUepHhKXzXx1vZiKokw0MIqwUHPA6Ztgurpat4WT8k+6YLQNKe09zoKEPDDQpYqKtlQM1OIBPNTqbUoMzZdl0vDVuIfiioKn3yiV/zJR2ZgBRjWrFoOl5qsFpT750RpSmQJWvXI4bfj7CvVySrpgDqeoP70f96mugOu6rq3XRezPMORSocAoF7QSCriEZjQu3o9Wi9T3AbMuPkUtvGyuA7InPtTUqvmx03W1VU9S5TaUad8kpqPOuUSnsA3A8XjdDOUx+RGZEiNuuVn/bJ3iOlwM5fyzMSiZGQYSSyUrZb5chu1zuXiiTOtv4DBgCckes2bgpqxd4wB5N9fR4P9jgcsvImqwjycRCibsRq4nBgoAb99UVjIW1jBU6rdmHtj9pgS04c4n+yWdjHGUvMKUDqjuoJGtlU2WHdPwScs+1B0+tWfdd7AcopMAJ9gVq0nFBDTAxgTrXR/L8zcjFJfWPZ5aEZS+ng+Ft6TWQjbG8fh/K0g2/mIVq6opnjYTGP5ZYQ5a6V0qvwWbzvAFfrWzJNntgqd5yk7up+9uhzeOosOq3m6qFniStr5MNRM3gDTBno0ww3tmL2yzc7+dIFtnsEfJHKCUfjyiUnQTosYabET3x6IdBQqz0Ux0d/q4GAAIPlhLFc9e8VflLQq6GCX7dcU4jTqi
 AHbAGvdG
 SOdn1p6g3KJpQa+D7U01opDkOZekadC/spou07+cOiJ7a1Zfqc94IvFLaHkmHka/TAWKqu3FxnrjOmRP/4jAeDlMCvwiAsUrcQ7AfQNPEQDEr+suKYEu8wgoHkX1D8w2D3XT7TKBmsd8DOJvkiJPY0ufFZX3t8yi49OAwA/7UCnFJgQ7L7g3DOv3NmncU+GosEzstZpKTNKjR01piacFnnAf0Nzxo7AkKA3NcsviWNdgq/EHcMwhzGFOKv3dAoHB2klfCKY/bvTT244VdBZnOA4pUbR5ygwaaze+SQG4Ui7COxSyhtkOI9kxZFM+55Qj/KYbyvZ/jrxH3/JxqNjBUfOtOrPauy6mjH7gNMxnjCLffF+Av2krG9fViynRgEywUvMSdnLL73QvTWsPMX4ZIK7U1H/rq1+ajJh66TrMGl6+bA5HWEDwtrIaYmCCKhTNXOzYb1X3rGma/0jlp9Nnw0Mpb5jBoTn+ZIK5AnY/4TyH1M4s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> After a memfd is retrieved, it immediately goes back into "normal"
> operation. The file comes back unfrozen, and its pages can migrate, it
> can be truncated, and so on. If the memfd is depended on by something,
> like iommufd, that can open a window for folios to move around before
> the consumer can re-establish its references.
> 
> Finish is the conceptual point when a retrieved file can start to behave
> as "normal". So take an extra reference on the folios and freeze the
> memfd on retrieve until finish.
> 
> Suggested-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> Link: https://patch.msgid.link/20261103181916.2462825-3-pratyush@kernel.org
>
> diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
> index 6b68220275eb..5abb9c0956af 100644
> --- a/mm/memfd_luo.c
> +++ b/mm/memfd_luo.c
> @@ -55,6 +55,14 @@
>   *   Only seals known to this LUO version (see ``MEMFD_LUO_ALL_SEALS``) may
>   *   be present; preservation fails with ``-EOPNOTSUPP`` otherwise.
>   *
> + * Restrictions
> + * ============
> + *
> + * While a memfd is preserved, and after it is retrieved until the session is
> + * finished, its size can't be changed and holes can't be punched in it.
> + * Operations that would do so (``ftruncate()``, ``fallocate()``, writes past
> + * the end of the file) fail.
> + *
>   * Non-Preserved Properties
>   * ========================
>   *
> @@ -383,33 +391,56 @@ static void memfd_luo_discard_folios(const struct memfd_luo_folio_ser *folios_se
>  	}
>  }
>  
> +/* Drop the references retrieve() holds on the folios added to the file. */
> +static void
> +memfd_luo_put_retrieved_folios(const struct memfd_luo_folio_ser *folios_ser,
> +			       u64 nr_folios)
> +{
> +	for (u64 i = 0; i < nr_folios; i++) {
> +		const struct memfd_luo_folio_ser *pfolio = &folios_ser[i];
> +
> +		if (pfolio->pfn)
> +			folio_put(pfn_folio(pfolio->pfn));
> +	}
> +}
> +
>  static void memfd_luo_finish(struct liveupdate_file_op_args *args)
>  {
>  	struct memfd_luo_folio_ser *folios_ser;
>  	struct memfd_luo_ser *ser;
>  
> -	/*
> -	 * If retrieve was successful, nothing to do. If it failed, retrieve()
> -	 * already cleaned up everything it could. So nothing to do there
> -	 * either. Only need to clean up when retrieve was not called.
> -	 */
> -	if (args->retrieve_status)
> +	/* If retrieve failed, it already cleaned up everything it could. */
> +	if (args->retrieve_status < 0)
>  		return;
>  
>  	ser = phys_to_virt(args->serialized_data);
>  	if (!ser)
>  		return;
>  
> -	if (ser->nr_folios) {
> -		folios_ser = kho_restore_vmalloc(&ser->folios);
> -		if (!folios_ser)
> -			goto out;
> +	if (args->retrieve_status > 0) {
> +		/*
> +		 * Retrieve was successful, release the folios and unfreeze the
> +		 * file so it can be used normally.
> +		 */
> +		struct inode *inode = file_inode(args->file);
> +
> +		folios_ser = args->private_data;
> +
> +		inode_lock(inode);
> +		memfd_luo_put_retrieved_folios(folios_ser, ser->nr_folios);
> +		shmem_freeze(inode, false);
> +		inode_unlock(inode);
>  
> -		memfd_luo_discard_folios(folios_ser, ser->nr_folios);
>  		vfree(folios_ser);
> +	} else if (args->retrieve_status == 0 && ser->nr_folios) {
> +		/* Retrieve was not called, discard the preserved folios. */
> +		folios_ser = kho_restore_vmalloc(&ser->folios);
> +		if (folios_ser) {
> +			memfd_luo_discard_folios(folios_ser, ser->nr_folios);
> +			vfree(folios_ser);
> +		}

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com> 

Side note (pre-existing, not an issue with this patch):

Initially, I wondered whether we should disallow auto-finishing an 
unretrieved memfd, in case a preserved device still had this memory 
mapped for DMA. However, if we reach this point, can_finish() has 
already passed for every other FD in this session, which means any 
possibly dependent FDs (e.g. iommufd/vfio) have already determined that 
this FD was not needed to be retrieved for their states.

-- 
Pasha


