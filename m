Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DF41606A8A1
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 22:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=IPT4+gET
Received: by kanga.kvack.org (Postfix)
	id 7C1316B05B3; Wed, 11 Nov 2026 17:29:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74B936B05B4; Wed, 11 Nov 2026 17:29:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EEDA6B05B5; Wed, 11 Nov 2026 17:29:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 279606B05B3
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:29:28 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 375661A04AA
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:29:27 +0000 (UTC)
X-FDA: 85424280774.16.122BEEF
Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com [209.85.221.179])
	by imf13.hostedemail.com (Postfix) with ESMTP id 372FE20004
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:29:25 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=IPT4+gET;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf13.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.179 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794436165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VhufRV4BoS98pezOde2Ss8la06aT4y3vZY8jTMf1PWs=;
	b=GoYSg7IW6tHOnAQ8jm8FoZPiXF6Al3AhoOh2ET86Xjx3vuGDg2tI8AUZ1JdJ2Vw3tftHmp
	H02YJrgvsLybJdo92gE3dF8xU/LHU08G+i4eCn0DdMmvy5+aMUxBkfequBJ/mSt/nrFs2F
	MPE6vG0ovdYVGE5ayFMfyJ7fzeC/h04=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794436165;
	b=6FZ8dsgkQty+STdi65Oz8XFg4eYkgzy0j1cD+lla1rlzst6I5VpNJ+I0QuXBdutVjlnSlx
	evX1b44rTLzU/UqSN0Pxpq+yPgnQXi0ZWP/dmw17WLvItFr0xl2kUvT1s/pSYxg/b4QR6X
	HOyYgWFjSG9YEJfx+si5/dGj48q/dvU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=IPT4+gET;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf13.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.179 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-vk1-f179.google.com with SMTP id 71dfb90a1353d-5eaeb7fdda2so2215294e0c.3
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 14:29:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1794436164; x=1795040964; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=VhufRV4BoS98pezOde2Ss8la06aT4y3vZY8jTMf1PWs=;
        b=IPT4+gETJTWp3qoxC+tWmkrB/eFtc8TWnr8i+uNBInpYUls2zAVHG8INoncS4V5E9k
         Xj3iOC8Fsnt/bLC1bBDlpXjWHLoTLcgkPTulpzqTXQ2gOGLyJaUPeSMg3SuWESCVVeVs
         T+/bLo1N9qqw60fWNrhRrHoCEzk3kspQjnzy44YFaixoMxkwwGe5KZA9RbY8axn80Sjd
         yi+uaoK+iTQHlM9h2sTXV4GsIK+e231RERJf4cwgL6Y7av6AjzmnL6NZa8sptVhUUfWR
         /hZrOay1WmwHupxsNgAxiQZPHl3l+CiNILZmzy8uCV5gTTEHI5+cbkReojEPDJi56z4Q
         Eabw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794436164; x=1795040964;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VhufRV4BoS98pezOde2Ss8la06aT4y3vZY8jTMf1PWs=;
        b=w63QftL78CjrpNMUtnj6Y034jci8vR938UJta7dU33+SqZ5Eg7ieB0UC2lAzra6qv7
         aQYdNrzehgV8+e+vGLLi57oLMrkEWX+Vq71SDFw5Lr8reZJvS/+kQDOty/whLgFVH/Gi
         JnrWxS229V+IvRciCwSj2lSOYuJIRe/4JHwPUMyhGwrkJBLkHOm2AIvOOs1XlGOZLiRi
         PLM552ew1o3FUrJI/DqhWBVA+Obvx3iaSsQOtlvJOdRNHAfSfjF0Stp5JpzszLwcmxYk
         3B4vxBLkSXky8sotYC51Gn4ZTaFb9evRz6eU92DyYeCYFbbxlDNmDANefs0vaUNgorSQ
         Vw/g==
X-Forwarded-Encrypted: i=1; AL+hErGenXKzGu9XAIz3Qx5ARhbdbyDtYVKi2O+NydyTDap78QHHcAgdRvLAf6hE1c+HmRYUMA8tXaXpiA==@kvack.org
X-Gm-Message-State: APuU4Z+SNs3cXp1Vw0zWwYTuzjJf223OPKeMY+RhXp/E15cdl7R5JLRd
	8HkxV98Zu5SAAWXz32HsdYy6v1T1qsiMveFFC47DQhxQLeJZEFmMW9CDGyJpn2BHG+g=
X-Gm-Gg: AYBFou2iWW8YtZeyJbAaCVKWDf1K5UPdqLkAXvWGVhfyQkUWGwaznPqkJEXPqXREyFI
	qV+h/2KM1yW1J18ydUs1mVMRwhTKlYA3qjRdfAVU2tp2xZY82Bk2anV1aWmcreeTra1yp9s17yq
	SlTbYdVJGxoQPEMbMYswOtjiuEIeplBtU3ioaZulIqcQsGjMXcOSfjKXsa1LJpoyNwxsCYTKfbx
	5MhKlR/NZ7w0ScDK1Yvv9ypJ6mc8P0EyUOoqcXzfH8OW4ofGNXXJ99jthOUiqw2PagRStHtqP9y
	OK+3dTmgvsDmzYyy59ewPh82KrGAJPxtMzOX9+9Kqs2NF+lhpVVrpKQVtX99LJApMKjQaL4lPPE
	jXVKWcmvykwb7g7fdlnhzJsw8DYkl14JsJjqHQn8NaKTKbhJLFtUtAQtePnGieyfU+SPlnNGk/s
	7/mVsQRWmjUNEM6TviMJdggDk/ler23v5255ArczKJEaNwr8tUV1eQGqanAyblLm+xib9hPT1hs
	hp5ZbywpezP5pNdwHgYw2WuAGBM1nEqsDd0ynDnCT1xNBMM2eRenhDZONQcCv1p0fkz/P6UduFG
	j8HjWjGNbZtqoXoi8Lm6xbQQE4j1byTZ3Uxc9FqlmKdjg1dh9lnE/5i1pF9185sYoMzBlU1ztQw
	6q1HGNwvsX3CxAcla8DQt8qToKqf82/4mXcVJNIL1SzYq
X-Received: by 2002:a05:6122:4210:b0:5ec:d84e:3833 with SMTP id 71dfb90a1353d-5ee1c453cbdmr1849715e0c.14.1794436164290;
        Wed, 11 Nov 2026 14:29:24 -0800 (PST)
Received: from soleen.c.googlers.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ee0c58ee8csm4508834e0c.6.2026.11.11.14.29.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 14:29:23 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/9] kho: Reclaim the metadata page left reserved after
 kexec
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Chris Down <chris@chrisdown.name>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, 
 Breno Leitao <leitao@debian.org>, Alexander Graf <graf@amazon.com>, 
 Baoquan He <baoquan.he@linux.dev>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, kexec@lists.infradead.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, kernel-team@meta.com
In-Reply-To: <63ca64c004b296a998a3e531f8c0c4964916b70c.1794383544.git.chris@chrisdown.name>
References: <cover.1794383544.git.chris@chrisdown.name>
 <63ca64c004b296a998a3e531f8c0c4964916b70c.1794383544.git.chris@chrisdown.name>
Date: Wed, 11 Nov 2026 17:29:20 -0500
Message-Id: <179443616043.2329176.17166425351392983946.b4-review@b4>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2439;
 i=pasha.tatashin@soleen.com; h=from:subject:message-id;
 bh=jGQo4CvboZX/j4iYyskgIcnUkGUfctp7MromfOrLaYc=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBq9OxDl5eSqxBhOZE5p1XG7yi8PQ1rOiwUmOTWN
 tSoxjgP6WuJAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCavTsQwAKCRC7dyhM23N6
 3uNSD/0Wo/iIWR2aXRe5YzNSrRfo/731JlX1MXOtpy+A5vTlCNvhVm398rzpLHqepWduInwcdRK
 4tex7caWuDlEdOt+RIVRYZ9mDjBo4xRQ0pvDBu9TWfu/8iU6zATD9T2YuP0IZnK23JCBq2LZdNL
 Pd1ZB7+If5y2zy1PJcSHbWDjJR9cu52ZsvA6Ni0FgTTyy3SdqMWwntgGPXP/LkzxuTKVIxTCew/
 zAi8DC6COcIzjFKPckc3lqS4x+o2s5Zwpfgfa/yAKCJIXNcdgmZhS/bqjRG1k30OiLRzjm1AUH0
 +/Wzasj+qb7r0d0gsdRO44Q3LUAgYoBNNtbFLy+xdLMwqLcDpWFCNFIsuQoxoTLzbNi/ldIvWM7
 Bhe1ME5c/vfVxRfgVtSpaG6iwt7oCEesTRczv6SaBP0L2VXQcphd+4/BXqpxAX3OQlRgygYDjh2
 1FlvPx3aw7hsvLSA1SpUCaE1/h4TboRhZXeYpX7Qjfo5WJMt9pwdUSkpQoQ/IZ0H7DlnI3dcKAJ
 LKGf5Y3yLsfxcsbOghJ6yLAHz8Qa5p2lyNP/Jke0X30ny06+HzRS9+hTk2lJkxIc+bfFW/kZkt1
 l4/OofVK10BUEKi4onJaayj27ChYPFFdnwt9J1sO+PHCisIKLgi9L8aR/AUtsyOX7ZBzKO2lVH8
 P8fa89xifqHqa4w==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp;
 fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
X-Stat-Signature: t65ygahty3ksqt7mx4dazi94ij9rs7tz
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 372FE20004
X-HE-Tag: 1794436165-106316
X-HE-Meta: U2FsdGVkX18GyV85UTxSq7iZmtqzl8rBWBDBetZBNA2ljM/f2QVTuyVNhGWGbOYTfC5eOu1hZp/ssc8dPdf2xvfSFBw6vj4J2EQf//akHz9dYovM1StAQBDlFffNYvXsEsSxnJAaV4leMwiglnKkMunWJ9xUpGjICDoF82XGIoJi517BRLoWvLB7GIvqVXyFEQfgX8eir1Vv17PRrnYYMRc/kFSwaCUVL0P9AiRWjDCe5PDVbAL2WhMXC+7sm+60DbRmpNOxPx/+NJs4C95zExLIBtF8zeRlkOhCkcuNPWMQnY4+mOalxiTKfhvgX5dApcRi//PVrSAWZBcBBjkoXLhaevOWDSeNuEZUAH/KrHiO94Ywe3RJlYrnhTu6zhI8PJyZjluWR/xDfycBlUfV8aJerqmwGG7rLA87nmwPv1Z4B8c06HgPSAkoPEG0kc5H7I1i22x2rmbgwRomBXXv3ZLkmfF0SqcxYfayyYaaixcHCsqZ4tFs1p94tCUG/vSvr8gx4fMj6QhfWRPffNyBJPY5qI2UeUyApQxmQBl+ZCCblbPzqwKC8Dk7naGJIU56iFh88OyN5ys/Eh77zpIF5vtNjC9IX1+pMR1cfmWBi7oaMU7oX+kDGkmHixtW8ADgIwivHwqcYNYsFQiZZSvk2ErYlC1vTVORBQi8WoyCgDheLccrrr6luq0MJfjbABrtnUNenwbfJKcbU7xZHtnbTtDqjNKo7MR3qmlKayM4W449r5a5o27vAjncrBpBUIzzz6/i366uEGvgDTR8/tGfIPDW2Y8FRrgZ6lGCSyptwIj9CqkUQdLyEgbkmPGLY9FwH6ZsbPMlwdW3vCqfv28dKeHdLkqrAC/8HT6q6v4kiOnJjTHN4pEsxS72TtmGS2qt7eqrlSzWQTN3suJmGdoHYFr7/f9jZ6JeyOlDPEqDdq0qnB3nTp+kNlGAbPH1lGCMFDEwiiNf9i2P/iTHpfu
 DZpfpASm
 Saq56lXWBtoZf5fNIOKonJFxqeNaHCe60Eil2skW4XIlTk0Ia1i+ZiFWHLsx57bFswb5IwuuguuQ7DextRDsFhQM37ElbLDNizNiYd6AHoMmq0Cv+PS+QQNXviGEIvQl1G5jJEhcJiQaY5ZFywEiaFF1a5lbDe03sqQ+OBDgbSKyCinKTEc7gtufPOM/1y7TSpjj/L3ozcMLNd/mHKCUT27z9zOga6zBaN1Opzhrs4z64OckPeNUofwd0KK2U57cy1hMxQGQPA/7BgroNfGAGn/i7xxmLSOJs8eU/3+qnssTyNIMSKPugtziAJqMinY7uRJDm4F/BZGQz0WUsrt0xAPZOMw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> After a KHO kexec, the new kernel keeps the page holding the previous
> kernel's kexec metadata reserved for as long as it runs. It only needs
> the page once, since kho_in_kexec_metadata() copies the previous release
> and the kexec count out of it at boot, and nothing reads it again.
> 
> Free it with kho_restore_free() once copying is complete.
> 
> Fixes: 76aa46b9e404 ("kho: kexec-metadata: track previous kernel chain")

Do we really need to apply this to stable? It behaves correctly, and 
your patch performs a minor optimization by releasing a single page back 
to the system.

> Signed-off-by: Chris Down <chris@chrisdown.name>
>
> diff --git a/Documentation/admin-guide/mm/kho.rst b/Documentation/admin-guide/mm/kho.rst
> index 902d171a780a..f9d2cc5999ee 100644
> --- a/Documentation/admin-guide/mm/kho.rst
> +++ b/Documentation/admin-guide/mm/kho.rst
> @@ -120,4 +120,6 @@ stabilized.
>  
>  ``/sys/kernel/debug/kho/in/sub_fdts/``
>      Similar to ``kho/out/sub_fdts/``, but contains sub blobs
> -    of KHO producers passed from the old kernel.
> +    of KHO producers passed from the old kernel. A blob disappears
> +    once the kernel has read and freed it, as ``kexec-metadata`` does
> +    during boot.
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 6f1f55fe3181..8a07783326a4 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -1782,6 +1782,9 @@ static void __init kho_in_kexec_metadata(void)
>  
>  	pr_info("exec from: %s (count %u)\n",
>  		kho_in.previous_release, kho_in.kexec_count);
> +
> +	kho_debugfs_blob_remove(&kho_in.dbg, metadata);
> +	kho_restore_free(metadata);
>  }
>  
>  /*
> @@ -1859,14 +1862,15 @@ static __init int kho_init(void)
>  	if (err)
>  		goto err_free_fdt;
>  
> +	if (fdt)
> +		kho_in_debugfs_init(&kho_in.dbg, fdt);
> +

so add debugfs node here.

>  	err = kho_kexec_metadata_init(fdt);

Remove the kexec metadata node here. While this is somewhat unintuitive, 
I do not see a better alternative.

>  	if (err)
>  		goto err_free_fdt;
>  
> -	if (fdt) {
> -		kho_in_debugfs_init(&kho_in.dbg, fdt);
> +	if (fdt)
>  		return 0;
> -	}
>  
>  	for (int i = 0; i < kho_bootmem_cnt; i++) {
>  		unsigned long base_pfn = PHYS_PFN(kho_bootmem[i].addr);

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

-- 
Pasha


