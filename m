Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC1841039892
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 20:10:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A0D76B00D9; Fri, 27 Feb 2026 15:10:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 274E46B00DB; Fri, 27 Feb 2026 15:10:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14D756B00DE; Fri, 27 Feb 2026 15:10:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F19E66B00D9
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:10:07 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 797318C7CA
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:10:07 +0000 (UTC)
X-FDA: 84491328054.27.520D203
Received: from relay.hostedemail.com (unirelay03 [10.200.18.66])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0761B40002
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:10:04 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772223005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DUhf1JuSB9OPze92qz/d6HbXdXDvs4qBvhHKIVZpPP4=;
	b=QcGR2BZUclhyu19FRpVKYzEARhBlTja+raLrNcaRxnJY8AoOIhaGXvttz0i3T6s+4tRLH6
	N2HWerxPkykknullAZZtK2nCHd0t0BwXs6mMOumi75Gm680VluTDpkaki5MxblwIg5nPAu
	pP9TUPNaiTLXdxjQtEwb9Epf2pkXUHI=
ARC-Authentication-Results: i=3;
	imf01.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=2")
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1772223005; a=rsa-sha256;
	cv=pass;
	b=W+SQIq2w6oBtxwC8f4wYZJB426c1bVy8Ohn2vdbYHdLasqkWITRbAXkxz1Oq6+174XfKHI
	WKEaQQssnQzEKWjr9mADUO4qViVe6YXNtiTlXq6IC7BBsAa4g9BA0HIbEc7seWpbAn/dma
	W4/SoXuzT3XFSNDfRIC4TP9AWTJPQKU=
Received: from relay.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7350EBBE8E
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:10:04 +0000 (UTC)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 430321B82B9
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:10:04 +0000 (UTC)
X-FDA: 84491327928.28.D5BA56C
Received: from relay.hostedemail.com (unirelay02 [10.200.18.65])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4436F140008
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:10:02 +0000 (UTC)
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772223002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DUhf1JuSB9OPze92qz/d6HbXdXDvs4qBvhHKIVZpPP4=;
	b=b8OT9yRh42mxK/cjaf4MJpct1OyxKetrT3NtDFkIwCu/M4+UD9szumtmpA6zLyx946/GpW
	AgFgu3qGMDOCFABzRJC9RLRlGRwr7YXzbluHfDafWYxUwUCmP8rGYUDkgxHLNMqs1JcwT/
	bwW45iSqnWl2NK9wB9LmCXHg8SmsISU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772223002; a=rsa-sha256;
	cv=pass;
	b=24gOyxZIxk2QpThcrwSYpQHHntnfxk3Ex81K6DC+2xGZHCOtkfw1d5wXybKouvqgIlg36R
	3TP0N5KO61uxJz2TfyjGts9w/rt3b/iDsAylhTGqkDMOTGF69WzTX3RXw5yLFnXsarfrYR
	q/c9e7CU89oTfEUYRAeiNIfZXyl9jJM=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
Received: from relay.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C2F0713BDDC
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:10:01 +0000 (UTC)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8CCC61408FF
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:10:01 +0000 (UTC)
X-FDA: 84491327802.25.3661320
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id DC061C0013
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:09:59 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772223000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DUhf1JuSB9OPze92qz/d6HbXdXDvs4qBvhHKIVZpPP4=;
	b=esOj247NQTiL5Jm5NoNdZF3/fzxU15O0N+kVaLJ3AFifP8vMk1sh/wWAGm3L0X7a0vwZMD
	c4OCOea1dH6xASv3IFNkgLYNM5kvQ3Skgvz98fzlAgHu/AcfXOUXpPdh9BSgCbh/7+kFdY
	iFQsaNbOPId0RLHUYjVNhjrWyrbl+ck=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SKSqFMwc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772223000; a=rsa-sha256;
	cv=none;
	b=g+pfdhyjBi+fciBELpSsuDgd82NqB3+rO+T6HoeD/HXePooArE8IYjy2fcrACaHNTkcA24
	fQX7/PwqE5e9Yb6E803e2xwR0fOnZCvjJAr9P+A0s9LicNCR/pMaNHtSw7qFhm410c9cCs
	NESeSy9DPFWILTlOuDW2k2mnfJqQAkM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 04D8A4417E;
	Fri, 27 Feb 2026 20:09:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E725CC2BC86;
	Fri, 27 Feb 2026 20:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772222998;
	bh=6LDS5+Vnu1htyspttVgh9zMYsh7tIZY4ma3ymZBtFxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SKSqFMwcnc7VlfFpJ1YNAbm4Z+zF+/LGzUP4CQ7sh7kvhpYmsBKfiG+nk4e+qHYLY
	 +Cdf6OJiVUJQfBE1Be1Oajv2J5qqAr7rTEQSaKgth6pGitrG8Hc1wPVk2TOXaWSysY
	 5NZBg2/wRYlKWBg3m+g+8mhjmq7xDqKiE1UDk9cYXlckyJFxfD5ezJwIvK9pjt6B0f
	 +9uLN2/GF+QIAANdneeZojFKTbtzB83JiF1S8jiEQTloHhUkWPaWDcFKguB8BRteav
	 xs9wWSj8gILbDPly5WkEX4gjf8F5WAVfUBqcy1dk1YtENH/MRugbDFtWtjB0lCg6Ka
	 Iqb4hdLjMfU5A==
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: "linux-mm @ kvack . org" <linux-mm@kvack.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	=?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
	Todd Kjos <tkjos@android.com>,
	Christian Brauner <brauner@kernel.org>,
	Carlos Llamas <cmllamas@google.com>,
	Ian Abbott <abbotti@mev.co.uk>,
	H Hartley Sweeten <hsweeten@visionengravers.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Dimitri Sivanich <dimitri.sivanich@hpe.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Andy Lutomirski <luto@kernel.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Eric Dumazet <edumazet@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-sgx@vger.kernel.org,
	intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-rdma@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	netdev@vger.kernel.org,
	rust-for-linux@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH v1 03/16] mm/memory: inline unmap_mapping_range_vma() into unmap_mapping_range_tree()
Date: Fri, 27 Feb 2026 21:08:34 +0100
Message-ID: <20260227200848.114019-4-david@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260227200848.114019-1-david@kernel.org>
References: <20260227200848.114019-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HE-Meta: U2FsdGVkX1/NOSgsJmv7I87gZYYvAL1HvedddRcu0hOaez63LO3r/RZeg5nSEJuUd+I512ZCpKgSbAHRHLLWDg7yi+v8yIGzSj/Y2t3OpqvKCKgE/77MNauB2LYisw7oy/5v2DREQc1nBwHmEzq9KtKRd5G36MOqUffyHP77haimJb919FlvKfeRqIRWugFB6MeCRTV0AZgT5zdXoMbb9kwZPzbQe9QBEQDnFSEcLLBu7uk/y1xkkzofqATTo9CzaJUtnsBERKy8adleKKI0uyahUDkjm5H/ilvKAk3AM6hEkradMjWsJVmX/SvhmG+O96NEcTc//kba2pwQooLFOZm6UfXoWq48ofiF32CnVxcPXqMFGZh3+VpMxYtyidWM/W5083Fh4auHFpbSuLF8Za78T5vVOle8dzEUM06C6gJBw5e5pXFhtzZJclOum5ba7ivFc8mzBb37kgg0XG/pFKXsBCJuFDIOZ9Rit2Ah5BpIrbkqZ/iGssH9DmHGLgzL9PwHPq/2E3DzCGMfRhOEcJb03RX65smafSTZKanVlKPArla8wJKaDIUQNnKl6vN5mcWj4WpBacqLgLg2pINjbh+aWbtErPlNMAuTcEI6d+waR2R1cv7gl9guzSyF25MAwkQS3++qJJ7Hq7VHZKGiD89bMmLnuaW1LH1NSnttrHoFSzVNQ8lT/C+3YR0MtO/vg3VRT35SQ3tr/5jeYwLN1+JsWXQUX2a5JG9alF3LI+qnpfHYV4r5UU1FIlhEYZh9xYGHAvO32HLUcpo4LuaFEfai21VtdzD9FGi5oI23y/1qiSJoYEKUkxU3vokFPu/RKeC9at+0LLCnwu7ylFVLfe9XOpBhRnXXULgJ7fAKDbVU3KrwPwr6Hz1h1CISimZPTlR5HEwUHvvm6S/vKnb0f9dEdhz8IjIKQBv0/2sU8YjtbsasbFDrDux2O4VJjpmGZlqbsQFWfEcOUci00uj
 3r/Ask1W
 jeSKzsIzCyOZNdcQa0bPoCUHCHdWlukrXcTbd6PJ16JiRx24=
X-HE-Tag-Orig: 1772222999-769917
X-HE-Meta: U2FsdGVkX1/j80zThISmGRLzh76AnD9P5q6BOhmmBVhOL7M9bmEVgtXXGmpuR0MX0NNpy307RDXbXSms/zzg53Ky6RDYtpZ8pIYmzFRAWi3y492Xn2psV9b3Xe+2q/MiNJTb0D5NRc3ILG/zOdpWsajYUEc3c6mL3T2yBaPlywdHgx/3A+hooQ3plAiHVmJT8kV3bcMuT16Wq7rayxaIYBbflG2B6C+OysfiQsIC6Cluw0JSjsZDQyAnxt4MOh38J6Po663mO/bRXeTCu7gCbsSJb+n4oi3mUhyihIeqVPiiSG9Dc2GJMV8YWntoVbv8AFlYHwnnr4ohnet40fRTFBEMSptvcNpjP4TPCoh4g1wus3Aj0FRZcdoODx7231dJXShzVqBupTzIj4aXWc0UZWsHc+7YOelYJTKkeDb/8pP3HZSnZvmK5apO8KPQQ2Hf7A6iVoRVeP4qBCUcpGLZIsm2C1QP1R3U45xCWbmcFNcYCANqg5K+QjmVXq4asjvIZUtMERLdB/Tzq4llaBnHNKDwUnH6aq2arPpCZodhwR1oM6s7HZyQZApeuXxL7vuNcTh61L23J//gMSY748Ey5JyYzN0wI3P1e9TNZsu7oijGoGnb/NflL7m2sFkKyIFj6m8jl/xZfR66C4IQIrRO4R1bL+AM650ohcY9Jd97j0P0kNqST5hSfMOs1LJwW1F9affxp3f77dENllCIwqL0K/GtOd5LE+XnMhM0MS+LEklN1ayuLokKDoHCaAd0VCZ9h0KUCJ3Bp6zBCq3SWv4kKDX6uv05Ox3pA8QzOnzyGZ3bNp6rJojpv7ZmO43w4ULF2Pmzppzyol/0pHn8gVjWMPxBuBpy4cY4R7Hz4/Vw5fHNPhaNUMvrhuc2InuGKgiVRzEPJriCiVm7jrCtfSNReMw5ei6z9SL3YKuii/yrYCrju4OiuES4lIbs8Ag9qukr7qEk7RZb9RwXM43qXzH
 tMjH61AR
 cRQNyQfse8M49snyWEHmsVc2WIWEe2lOs4T1jISs6j2liDvOViW02Yo0yZbn6Fb1AcRVBSSpmBPZtXpH5C+yVwEG++lxSsyXxTYySpO0C6xeCyHb5iIKEz73Kl+cF4IELUIrROfQ3cyA4mky4TnuX2EytyLg87hJqOICgsQUZ3GhuvdujdeZUeoCKxq7NP1Kb6weRaGY7ZBbFVUPpDpzqcvYWhYE/12WajNkPOG+4XRXfduAd7Eu4Yy3s0m1rsHKrCKj4
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0761B40002
X-Stat-Signature: 9xos9zzuijmxajq9ow6ucmffzsm8f45s
X-HE-Tag-Orig: 1772223002-346055
X-Rspam-User: 
X-HE-Tag: 1772223004-488736
X-HE-Meta: U2FsdGVkX1+YDnhU/ZIxYoKbPlsZ4zV64jxX0vhu9w7fZ8R1cOXfv+z0bv3b0+Qo7gwQSj6zV5D00dcJhRAk6UGiPBP+Ma8cmWFuOa+URv/VQRR/paQkLjCoAMcailN6nayCcb6AROlsh4Lsuw63HFH0KnuLCT6oTnDLmHfpLw27Ye3vus56YAZyVQDgs7SlnKSYyCh8S15T1OeGL1SfT1p6DusQu7wCPPhZhbcw9mlWYLh5zSvqe6EeQCNQW84f59npZ43EH0X0FiK7qHChWmkzI9hFsinI+wcMIyixsGq1Ax2e7YteanzbhKfOxxFVIW72s4he5vMV0nPskCrk8bh4f2Z3WnZLLdvrLfma4SSEvWNO7Q1OSxAORP0hf9HlpKvMs4Jvub33Nw24Km1JbexaIbE5ZgInvKMpeEareAgHQ+DqJP8xJH1omY+Rj5rdd0wb/hpgaXFlRDMbQ2tYvv8ap4aK9ZkTiueVahwJlAl5KyGKIuxtAl0AlUkM4GCLD3VU1SxsClyMBAoJ4HhdUWJ27PPdK1FCXzjRdlSWzzfEUKbOBOlKOwnV0yWw7S3Dqr7qqkrwJdoJB4gMUK6nFOLERbQ6MDbpN0gGfnFRDhM2I2Lth2iJ3XUOke3jnaJESb/YLVMi0ZLisebQ65krdfQhDhL6w0l5KUCo0YBzmjD8GnmceRKoOPlhEwpdhCmfO0Q4RMnxkST2Cs8kklgIqf5cn9duiQuNdMKLSuEgcSjsa2DEraR358o++jdJsciJTfwAjh6vUHuyO0eCXcsAb+VVrBhNp6XLdkiWewOwJ6NO2UpKDrEUS01Dzky4t2IToXSZSIVwIqCyVfXqJBg1KaKMn2hBoQzgxdlCTzyDZvmWjAAFiguORGgk4f1s3uizUd4z17dwuzTJR6zRuGvksSpIH/vEiDSOE5mR+u4OOfTfRh2/LyqBkPugM5DQs7kYaftDsOUD4b60b4wvTqh
 Eq5imK5z
 G82D6BltghMF4dGL1d8efAyJngQWGbeTBbwFYVRyzou4+TnQq5GN2k25dBEPrV8vlKcz3yV2YHw1gT/zD9+Ky7kJNBFug6nrLmuTfv+WHrSTXjilWdKMO2nDro7u3ee3jnAyeJGGCvboibD2B4LSD9P3UkgeNgV9o9Qxq/8qpBanWisQ/Cvn6ZACjhplVSqvsvv7LMuuHGhJp3vEFWx83x0rx+MAvM/u3b4cBxII4Et6vBFvHZS6a0kV1Ub2QLKp6xJDW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's remove the number of unmap-related functions that cause confusion
by inlining unmap_mapping_range_vma() into its single caller. The end
result looks pretty readable.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/memory.c | 23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 19f5f9a60995..5c47309331f5 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4221,18 +4221,6 @@ static vm_fault_t do_wp_page(struct vm_fault *vmf)
 	return wp_page_copy(vmf);
 }
 
-static void unmap_mapping_range_vma(struct vm_area_struct *vma,
-		unsigned long start_addr, unsigned long end_addr,
-		struct zap_details *details)
-{
-	struct mmu_gather tlb;
-
-	tlb_gather_mmu(&tlb, vma->vm_mm);
-	zap_page_range_single_batched(&tlb, vma, start_addr,
-				      end_addr - start_addr, details);
-	tlb_finish_mmu(&tlb);
-}
-
 static inline void unmap_mapping_range_tree(struct rb_root_cached *root,
 					    pgoff_t first_index,
 					    pgoff_t last_index,
@@ -4240,17 +4228,20 @@ static inline void unmap_mapping_range_tree(struct rb_root_cached *root,
 {
 	struct vm_area_struct *vma;
 	pgoff_t vba, vea, zba, zea;
+	unsigned long start, size;
+	struct mmu_gather tlb;
 
 	vma_interval_tree_foreach(vma, root, first_index, last_index) {
 		vba = vma->vm_pgoff;
 		vea = vba + vma_pages(vma) - 1;
 		zba = max(first_index, vba);
 		zea = min(last_index, vea);
+		start = ((zba - vba) << PAGE_SHIFT) + vma->vm_start;
+		size = (zea - zba + 1) << PAGE_SHIFT;
 
-		unmap_mapping_range_vma(vma,
-			((zba - vba) << PAGE_SHIFT) + vma->vm_start,
-			((zea - vba + 1) << PAGE_SHIFT) + vma->vm_start,
-				details);
+		tlb_gather_mmu(&tlb, vma->vm_mm);
+		zap_page_range_single_batched(&tlb, vma, start, size, details);
+		tlb_finish_mmu(&tlb);
 	}
 }
 
-- 
2.43.0




