Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8B98606A32A
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 15:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=tYx9S+No
Received: by kanga.kvack.org (Postfix)
	id E89D96B05B9; Sun, 22 Nov 2026 10:50:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E61526B05C9; Sun, 22 Nov 2026 10:50:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D523B6B05CA; Sun, 22 Nov 2026 10:50:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A54E56B05B9
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 10:50:33 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3E4EFA06C8
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:50:33 +0000 (UTC)
X-FDA: 85463192346.18.5A34D9B
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	by imf10.hostedemail.com (Postfix) with ESMTP id 57338C0007
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:50:31 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=tYx9S+No;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.169 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795362631;
	b=H5kgpS01tHMPj+COB5fkjyOp8+U1I29cCPB2nN7V+0fa8LNut0pv6p1L3GZKXTN4YXM9Zs
	9hL+7HpgIQSxdErSIYtjZ1Zlsz1guUnMBvyadLFmoHQseTHUx/53F87XBudMTIUr7F0DSs
	Jf5CKjQksg+zZd25IEZo/3PHCZiL3y0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795362631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sfE9ffid3qsS6HCt6GKuvhh3G4tRqIqs8ErTq4gAbSQ=;
	b=uFtBHCwdrPOSKjK75yJNHtN5tpktXnpfWAEL+Euj8zrpmroCabf7GbX5WyOs9xq1yTVhTJ
	UzWELIH5DWdZjoK1E0q/8qq0dMMUMKEMcEkeLgIugWKKyqyj1xU6iWUqw37UjO/8rch7HE
	SlDEap/0MTVwI8vECnCj9GyD001UjtE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=tYx9S+No;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.169 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-93f269e335eso332448885a.3
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 07:50:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1795362630; x=1795967430; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=sfE9ffid3qsS6HCt6GKuvhh3G4tRqIqs8ErTq4gAbSQ=;
        b=tYx9S+NoSITFtmoYvmiC4p9MyhFDTw5CS9SDujpwOL2M7YwDnJsHg/IMTL36QwwCt4
         Qq7ICufaxjeqrFY+hsY8+lm6QxNM6qDE8209JvvqtIkWHDaFUh0/0Z8COO0r6Zh1CRBE
         ygAbv7bbQ4CJYZyUOAs2aIxirqsR9uBrsUZiFtruwKKn3Uq3mXUo6ilNUf0CckmRPx7k
         NPdQjRzO1g6FoHINp3dBB7DlxnnFarfj8bw+iI7oF8ahR7bUlc1UbUH+g+4aMMs4uZPn
         9naSG4Tw5+To0EqdGE6tDOklz56PFaNmhN3/cHf0Qy2yx0gtTBFcFyCIvcWA2MrYj3Rz
         Pw2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795362630; x=1795967430;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sfE9ffid3qsS6HCt6GKuvhh3G4tRqIqs8ErTq4gAbSQ=;
        b=X+sQ1u1A6bqecI7fGspSOnL4BAOh6OBYN0tBmcpjDt89sXBoZ2xQ8LFva/qlf0QaHI
         0RAjNMuU5uD13vaEt31SUnShNhR79biT4FABxmu02jPz++CN22DzeBq0oH3nQP9LNvSm
         mAcZZY2SBOTH2jttoF9Xtt8uCETQBiVSUOlzlU4T7L8qjm11yFCf/WmTUNjMl7WFU4xO
         O61Uz9KaF7MoVtQk7GEYzcGKYtjASuQn3/6EtInfc+lYAYyzhUEoQ3XQxmJJlkpB4N+E
         DvfONZ9wSMZSpB/TcvntYD7uIy9iAm4RvfbakBhpE8OdFiWIPeyn4WB5obhkZZ1EJajm
         QHZw==
X-Forwarded-Encrypted: i=1; AL+hErGzZaQkY9A+iwMe2gwMz7ybOVFv8ERhPlXoSOKk120s1maeOsMoysZkPihZ4iboNxQXXmVgTnzQkg==@kvack.org
X-Gm-Message-State: APuU4Z9635Y58i+7Y4br30kl2gQM6ppQNCbb2TVTBbIUIDIMDDA3FPCB
	n6g+qQLr12M4tonxwP6FAp20td6P2p27tAJMJjE7fR7+0ZGz3/hRYVZqVT5UpgCZlyA=
X-Gm-Gg: AZFdTZebj0dyfHV4MhhmV6o79tOhAxEOeII3tlzBA3klSiSo5TLYcZpFfOD1gX6GWmF
	vPXkQYQqT1NBc359ZrQK7jmAAI1PcU6rUKtQdbekULYpYxq1i8glaDVyxDRn43GYCDKoClg8xlc
	etVLoyoxAX9FllvEB6WavSf2ovHhrztALHDlAQOdlzp3lnvBIWIvD/QFv4SIIKIzL0zHt+Jv553
	awl3meDhOUuRKxREqoPpop40ge2/207hSrynX7HxULTyYfEEORKbJuYd/EikOEdg5qajDV4XHmA
	k4y0xnUc6u5hzf6jcuckbj5AXmp6VXenqWTJvpc2v3Fp9rXVKgxpbElYzNUPdvny9RW/e6O6Zzo
	qRdjUR4mTfL19/a/4D82jA0Gdk5dqR+pzv7Z0J7Hix6zRGDjMeYH884ck5k1GgCOSNU8jkoRH3C
	YY96ZbHLf102cLcCY61lPSVsln3P8Xz0K8sZk+T1oaOVmwRt+uHT9MX8csTjpFDM96tDOL8+Mbq
	8jsEwTkBwpQ5pDyMrmcfhzF11WblwuVyljEdfv8KHdwdqwT2n2Glif1qM5ooiB4QAn+LvwJfOJs
	VY+oqCaQP8i1TYlAIJn9Rr/+9tWE5Kmv0k2SyefLKhDYJlo1kBDGSSSQKgxo5wPeqY7dOGx56dO
	2U6HUE/fJBD0NJa7hvoFtKbk9y+mv
X-Received: by 2002:a05:620a:4713:b0:93c:a468:2db1 with SMTP id af79cd13be357-949bab11618mr1604125185a.58.1795362630552;
        Sun, 22 Nov 2026 07:50:30 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-949bb41a341sm626128785a.37.2026.11.22.07.50.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2026 07:50:30 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 4/7] mm/vma: fix uncharge after failed stack relocation
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, 
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
 David Hildenbrand <david@kernel.org>, Jann Horn <jannh@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Kees Cook <kees@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, 
 Ollie Wild <aaw@google.com>, Adrian Bunk <bunk@stusta.de>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Hugh Dickins <hughd@google.com>, Joey Gouly <joey.gouly@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, linux-mm@kvack.org, 
 Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, 
 stable@vger.kernel.org
In-Reply-To: <20261121-some-more-ai-fixes-v1-4-236e925d9b64@kernel.org>
References: <20261121-some-more-ai-fixes-v1-0-236e925d9b64@kernel.org>
 <20261121-some-more-ai-fixes-v1-4-236e925d9b64@kernel.org>
Date: Sun, 22 Nov 2026 10:50:29 -0500
Message-Id: <179536262938.412063.9413830491196612418.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Stat-Signature: dtm74xfc8abh146ggdik7zg5mo5oe755
X-Rspamd-Queue-Id: 57338C0007
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-Rspam-User:
X-HE-Tag: 1795362631-374940
X-HE-Meta: U2FsdGVkX18no8xoqN/66E+CGDvPhiSmEmGIO5kUsQysPy3dtSH5zz5+qJpiUzjA6lT6DGfZbk7wXDY9N3iIH3xiBuAsKGOdbfDmW2M4JcSB7oZr7rJTT+DM0LPTwpfA39Li4n/DXAPxtQJHYzDJQQaeUfLIlCaifUj5yAMpJJqQGReb09kWkca1n2jiNigOFj1BLacKt31/LNzBDm9JWCD6TpyNdKRCn1MYLKO7wzEue8zpRduv+6TtmpDbmGcX+sMdjtQfEMIW0PiDcVXXBOgR7NomWLxTxv6xAVB1WPnANbgrzvvVTlhFNC1Dpz+ecjE8b4KjMa4E49PlKzAfEXok7cb3iNd8Mb5kgE7XIRTxzadWsB1zW+d1JXSIvw4KJz+SJw3KR+as+/zvLbPH4AbgBk8FcOzpEqEEnoylgNHk9xJiO0R/keAJnvmk7j76fHnVzVmsDycsnUUX5P7zPq3XCIcII/zmz6wOivob7mf2RGZozfTMQ4v0QIOvhyOSfgoJeWxjRkm94p/Q3b4xZdkBpUl6+PLnXZ6Hd+vswJtmUmk4cY8HOq72r5IJMevWM8O6e3giKQ4Q/UO0xCTfpC9ZlUjSks1E+Pa42wfr8XvH/E39jyGH3rbzSLiMS5fNd4tS28TW3iDgewkmoQ3H/F9dQf/dmWRbxkIrKLmJt5EV+PkvF29HHpAyF/GgNFnfVFtpITkchfCFvVK5+uXhhsWXBer1zQegWmh+9yqiKSa8w2Xj7P73uQWXyTlmkdLnw4e00mVi1a8jFJ8A5uvdYPA+g31K5aKfUrT1PZI0KFAhxHgvgMfCODWEpdVXR8VGPW40LWN8KnPx0arbXvR+l6NH1DmQGIA1fj23h0unz2KBHiRB+1UKFr/gHuq/n9IZC3drFFr7XmNlBcD85hPiUuP8V2nLbVF6q5xiyj9PjVdntEiZceWJzetw+hYL2yn6Ky/LrEDiWiRVszPfmWL
 yswh3nVC
 UA5uMlwEAOwoYYf59lbiRFIzv/RvTn1ddCorjjOOMxP6RAOYFRArUzSs/9eFoEOfGuTKgpeueMvf+qA93sj3rHWgmyC4d+v3BkQ1guSLsO8kSnW3nDatiIqsywRJ5XSv5Lt/aQH5s6UHWz7j3D3bP4q9i8S7vJpSno1IY8r7piT4hYf9VkaCKYNkcrIR+uWwtxURzSXgESNtwFc6y4Rvh2tynbTMNuB2wHAAXqkmEeYxuVN9pk20830ukxSxxlCOzOaLyT65iJJnTihnYYqD/HkHuZHX3hvv5cU+AU4gilRXzw0ZCApOghSfDZJs5U/vpYfUPaKqtraH+yW4sT29w9fPCKBm0OZfhj0zH55hr+U+6L6dYQvZd3VaBhUN1Y+HeVkQfGRTrnlrEeA/+dTwc9eGCRbatk/rmTSF6EApAlxGeCj4EozfJ/EfefNYv9DH2X7EAa4QNm6tbmyzI/kjwbrSju2a2NLpUf3y31NU8BxjnJEfxUAwk0gVjHruiLm6zrahURnyr/LV3DPE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-21 16:02 +0000, Lorenzo Stoakes (ARM) wrote:
> From: Chris Mason <mason@kernel.org>
> 
> An execve() that fails to relocate its stack can underflow
> vm_committed_as, and the commit limit of vm.overcommit_memory=2 then no
> longer holds.
> 
> exit_mmap() uncharges vma_pages() of each VMA with VMA_ACCOUNT_BIT, so
> the charge has to match the size of the VMA. relocate_vma_down() expands
> the stack VMA by the relocation distance without a charge, and relies on
> its vma_shrink() to make the two match again. But it returns with the
> VMA still expanded if move_page_tables() can't allocate a page table,
> for example at the memory cgroup limit, or if vma_shrink() fails:
> 
>     relocate_vma_down()             charged    vma_pages()
>     ===================             =======    ===========
>                                     L          L
>     vma_expand()                    L          L + shift
>     move_page_tables() fails
>       return -ENOMEM
> 
>     exit_mmap()
>       tear_down_vmas()
>       vm_unacct_memory(L + shift)   -shift
> 
> On x86-64 with 4-level page tables, the distance is up to 16 GiB for a
> 64-bit program, and about 128 TiB for a 32-bit one.
> 
> Fix the issue by giving back the charge of the stack VMA where its
> relocation fails, and excluding the VMA from what exit_mmap() uncharges.
> The argument pages of the dying task are then outside the commit charge
> until exit_mmap() frees them.
> 
> Fixes: b6a2fea39318 ("mm: variable length argument support")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Chris Mason <mason@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
~Gregory


