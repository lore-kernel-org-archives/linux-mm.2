Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DA07606A331
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 19:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=lI1mEl0S
Received: by kanga.kvack.org (Postfix)
	id 5761F6B05B8; Wed, 18 Nov 2026 14:50:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 527696B05B9; Wed, 18 Nov 2026 14:50:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43D806B05BA; Wed, 18 Nov 2026 14:50:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 169AE6B05B8
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:50:11 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 96CE61C429B
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 19:50:10 +0000 (UTC)
X-FDA: 85449280980.22.C02488B
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf10.hostedemail.com (Postfix) with ESMTP id B3360C0007
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 19:50:08 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=lI1mEl0S;
	spf=pass (imf10.hostedemail.com: domain of urezki@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795031408;
	b=4Y+Dj7YEU+wrBGmuHcpAQQ+j6JN/InLgP/LuZpgj2sne8aBnziimhInRDkcksCmQTkPhhL
	o7swpK/vB36k77pXYyV06t9PBoiKSPYY7tUnycYzYt2hmbLr/pNloDnJgwFpno57HO87aH
	1+Zl2U5roGWIQxOq3Xi6NeM2T2Kvyj8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=lI1mEl0S;
	spf=pass (imf10.hostedemail.com: domain of urezki@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795031408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E4a1CfB+dLHAk/zicRP0eJek0KQqRlij9qTOmYyyyD0=;
	b=EC7ymo2KrkSZhjEWNd5wRJplFH/RZ6RFNKYuuV2ZrgeC7MBq6QOozK4nuIo/DPToI/uu45
	KExOyo/8Eqxnaj0cjUCc9OM6QAXUCb+hSxxZHTgAEsKusZNlGDPirPpJUsHsKiMVFXzHGk
	eMWiA5XjQfxbxmO5TkjSlhgjQoomqBE=
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c5118deebcfso153332666b.1
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 11:50:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795031407; x=1795636207; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=E4a1CfB+dLHAk/zicRP0eJek0KQqRlij9qTOmYyyyD0=;
        b=lI1mEl0SzUIbhlvT8WcnbztkPVJ+6lJg8/30oVc00zm2o8PT4Y3eEomiVBigEm/LVZ
         VHmuZwS7zBZddLfkXS35yLZjUX/v8AHgabnr3exTbS9yMBCxZZc8x1gUb5P3mH1mihML
         6mzevuBxVHa6WZTc2nR9Gwtp4L1VIG3HZR2XAxsaTo5IYKGdRFRAnlI3wVoq3ET5QjNd
         b5g4TF3lHCL9geiKc2EZ5arockS5HM0aduiulHURqwHKpWt8cJ5cCRdWVRA0vF0yTIur
         qgalQ+t04SaoF3QGLiW2TKIbWy8w7xYHQpBsa0fanaztb3LXFUOjJOFz/K0dap1n6PjV
         pjnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795031407; x=1795636207;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=E4a1CfB+dLHAk/zicRP0eJek0KQqRlij9qTOmYyyyD0=;
        b=zwPj5ICDIdxn6BI3o6uHGVnAaoKWD6J0M8Hz+THbzU1Rjbnd6oeTXeYECnNVGIMmyA
         PMHM8b3a5cbBiWtSLKtald5JdQdODiNyFRaUKw7TnDlsEzx3w5/1rOlHxKtd8B5HWvZy
         bUu9A/SaHqwB5JZcibtxGrLvAsvq8pE9u1n8Ut4/BQUVkX0Rj+hqnJgV0aDXj062MUZr
         /NKPuGUPYc5tHiGjnmK0RdOtjIXUYi3Gr1Oeo1zk0K+v0GXSHOZz0OESdJnYgoLrybWA
         4beabaSdi++axR8MUgru9JRAJmxnJABNhZiIceDTWq9q7/EhHg6EVcceNcaRKDot9tLr
         re/g==
X-Forwarded-Encrypted: i=1; AL+hErGWlTFQSztMzjZ99zYZWZ1OCz2K7VLN/nscShQ5GCaM/rQmzDYSJLiwPisGCb1n2rt5a0WrJ79Bbg==@kvack.org
X-Gm-Message-State: APuU4Z/2J/dAx7vEb/lh/RpPCcrMZr7GAlwn6Owk3cSIHgx7PTFhG/jr
	6GaR1DTLXSRX21X81yrH7s1INJh1Xx/S1wLC1DrBO9qYdD34zMZ/IOmJ
X-Gm-Gg: AYBFou2/7rOwkA5Zfbh3kUic70tv/DyZntIv/+u+v9nSXTNwd4M1DcQCLdzCYuYse4N
	uxNCUYpHJF4dbiJkBqHYPPlLGUxrLLjkIkx8bJ6Ve6xiIO6+uV/wmG7HNYKGVbEQI6v8f8R6II6
	DT8A5Q2kQ16zSdQaKqvFkQtx54K7fV2U/VnFLoVZgN/2DfTpulAuImuAi9bRuHywcxS+uiVRIba
	/SDmzPSfZFHXE6twwgi9SMxxOjebQ7k5bZERfo39tBgWmNun8KznCsU3IUrPAMVAgo1oVp1Q7+G
	C5ylonQoCNEaGHQR4jtw/50vkZMGtqVClxbyIIevL7bRf20h5WU/Dg0r1ZhJXRepXslEh0hwArB
	HMrHz+RLqorHCJNsGF0znpyzFi2JQNW0xDRMR5riKKxiVQkzM+RoBV0njwaSbcJS8crWU3U/ghD
	gH50YZry9ew743uxVSe66oHrBmvy7ac5aeRVCYMpgEKXgeid/jdjc9aDRV2Iw7aJ4myOigyoP9q
	cw4hR76q1CHeLi0RoUA9Bqai7fRwis3em/RGs8hye+ymeiQO2Ue+hI/2IE6aZwvPGdi9g==
X-Received: by 2002:a17:907:9348:b0:c51:aa6:605a with SMTP id a640c23a62f3a-c510e1a6382mr365802366b.27.1795031407273;
        Wed, 18 Nov 2026 11:50:07 -0800 (PST)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c512341a3bdsm33510666b.32.2026.11.18.11.50.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 11:50:06 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Wed, 18 Nov 2026 20:50:04 +0100
To: Hao Ge <hao.ge@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>,
	Uladzislau Rezki <urezki@gmail.com>, Dev Jain <dev.jain@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>, linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
	linux-mm@kvack.org
Subject: Re: [PATCH v5 06/11] mm/vmalloc: undo what vmap_page_range() mapped
 on failure
Message-ID: <av4BbLb6SxEcRe-8@milan>
References: <20261116071325.263682-1-hao.ge@linux.dev>
 <20261116071325.263682-7-hao.ge@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261116071325.263682-7-hao.ge@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B3360C0007
X-Stat-Signature: guxnomygmy1drggtwjd4dso5nkoec9jb
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795031408-201980
X-HE-Meta: U2FsdGVkX1+QccMU9bed+qUY5VSrywo0J+0FN/4LT7LjYD4lwwkXGRHz0wblDR7X4jfPS/nMWE2In0qTGfREeDcFO3eEz+wTK3OQt5F0LTi4dhGgkPBEXxdWr7ykO6u2HKxvn2QW2IGfEo6PA+t59lyU0aXh7p2cHcnxLoyTfXbRNQWCjxKJjxUNf2HLa8YjEVBBWCAwqHeV58pAS78hQWRyK5sjsYWdxXnqJ2lqojHrkhPfsYoOQaBhIcrcBSxqJoRbyykMPuvhcl0lW7vaHEHyOHh9G+vkSKZ8lpkUURXnPM56F8aZ00lIGXHivo9rI9WEnRytz+3wFBobAMgMyjf21qzY6gN1mp4r1/p5NWQeqVQNOIUOcniUqezjcJLDFZth5RzEDhMO9/C+SUGip0Zvo92AmStyDAtjnXVi18uCL/5RX8HBj/4Un8gMPb03x9QmCu22FkNLdj5yDvE9yMqUeJzrcsQGOANn322oTs+EVUPm5bM/20Z4HkTaVQZTPKZ89ZuwQYg6xA5OoHgsnGbJWD1mROL5sz6SAK+nPK32tTWazDdjGL4Cc/p7CKZ7gQ9sKXt3VsH5AAnFyFWxMhcQJwuJNfpliwoQVMayUKfCqW5M7eMQu3tvhcicQJ+LMnRd2Go1C55xg+WNfnuLAag0mPmnIYm2ksV+k+e9k1X7hPRp2WfVFOJbkaikLzGDGySBT2bUdr0dP4yHKDNOG1UxFwlg4cSajfj1DW8fXOA660HdeGbbRkkKKhfer18TPRKGRcNMuavosc5s16A0E1Gakm38si9D4tAs0jSs4jsDtAtkKnvs7m3K86zBq3O9VNZdhJ+6X3c8T9+wrYMB0AklRA+6JyvuAMwZi5WyphTjcmsm64/ovkAB5dd4dX8uffBPhBugUrXzE9IGCdiJTW2VRKgbZt0zGjTZYbFHtl6B9PQHqxw/BCOsl+4AJN4dP4I5P01f+GV/f/IhbvA
 cCsbaL9h
 stucrmNa6gyNy7dR3Q7XmOuOiNxOs/8ufrzyR34407HOxWJE/Z0lPpdbq32U1JKR05RpL3mLIMpgJvenQMdIocLsgVE1gWvbdzeYQRLR8rHTCMm0UGJ/nT3D2dP3QLC2c0WVQnjt6IN6MN+fbL5jBt1TMkJEf677IEmZVSf7cdDcNivom3d6TQwegJ/wm2XqJgypHANu41f89BcCPs8by6QPgzirlVnhL+BaPOcOr5prCdbqNN2CAuF+YBSn9giF3yw8t4RfAUvqd12ygyR1S8FTauHCjzYrC5fR5pwGTGCsBgarSP0bTLPADaBjHu/O9uAdXhGLjdBF4WFwmCXFP3CSfwVIUdCsMGO+8VhNALdHx1ztj78WIy5QmCR9/CHGHgruWbZlZ/Q72XYWbR216u1ZURGK7F6eQmj6s/4m28+kUHlNvXjmWNgVI6Pk5d1RSAvJDZojd+Rk65Ic6RDtQixL8xzIALfyfwaQDMFHQ1pMupDVKf51HAnvJKS/fIzZpjzuMLFYQh51FGVBqtAqgUP7HTLwf2chlASL9r9MW2IqNBDJ0xEKs78hLvVo4xZZweHKzq6ScLdhiRmhscdXQqBxXtlagTr6NaPSW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 03:13:20PM +0800, Hao Ge wrote:
> ioremap and arch setup code map their ranges with vmap_page_range().
> When the walk fails half way, or the KMSAN metadata fails after the
> walk, the ptes installed so far stay behind. The caller frees the
> vm_area on the error path, so the next mapping that lands on the same
> range trips the BUG() in vmap_pte_range().
> 
> vmap_range_noflush() now takes a mapped_end argument that the walk
> levels advance as they install, and vmap_pte_range() BUG()s before
> it installs over a pte that is already set. The ptes below mapped_end
> are therefore all ours, while a pte above it can only have been put
> there by somebody else, for example when the caller's range overlaps
> an existing mapping. On a walk failure the undo is limited to
> [addr, mapped_end), going further would clear ptes that are not
> ours. If the walk completed and only the KMSAN metadata failed, the
> whole range was installed by this call and all of it is undone.
> 
> All callers are sleepable, the teardown passes can_resched = true.
> 
> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> ---
>  mm/vmalloc.c | 52 +++++++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 39 insertions(+), 13 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index d99d7710e1ba..5c1eacc2a0ac 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -117,7 +117,8 @@ static __always_inline unsigned long vmap_set_ptes(pte_t *ptep,
>  
>  static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>  			phys_addr_t phys_addr, pgprot_t prot,
> -			unsigned int max_page_shift, pgtbl_mod_mask *mask)
> +			unsigned int max_page_shift, pgtbl_mod_mask *mask,
> +			unsigned long *mapped_end)
>  {
>  	pte_t *pte;
>  	u64 pfn;
> @@ -143,6 +144,7 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>  
>  		size = vmap_set_ptes(pte, addr, end, pfn, prot, max_page_shift);
>  		nr_pages = PFN_DOWN(size);
> +		*mapped_end = addr + size;
>  	} while (pte += nr_pages, pfn += nr_pages, addr += size, addr != end);
>  
vmap_pte_range() either s=install everything or nothing. At least if i
do not miss anything.

--
Uladzislau Rezki

--
Uladzislau Rezki

