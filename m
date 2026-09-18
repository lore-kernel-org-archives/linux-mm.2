Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5E25C982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 10:22:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D36F6B0099; Fri, 18 Sep 2026 06:22:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AABF6B00A7; Fri, 18 Sep 2026 06:22:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E8E56B00A9; Fri, 18 Sep 2026 06:22:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 41B816B0099
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:22:28 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BF8C71405EE
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:22:27 +0000 (UTC)
X-FDA: 85226493534.13.31D3714
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2DAF018000C
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:22:26 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20260515 header.b=oc0rbtes;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789726946;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sHYNy5wwK9fmryuUm9WuegCfsJ5nAR1Rndu3nKXnWCM=;
	b=InNZq1Kc5r362pGaQRAXsAdxOHQnpf5ERPgyGIN1QrdjAplfZy5Vdkq2TtNHUGpWPz8mM+
	mbx9PyhCJMvTSalHPWO1bgIGvEx3W2A9fzIy1LLE5vtWzNSOkrKLsrWhbBb6oldckxsTzB
	Uzkg1hcn5Nh4Frn+XwGQ2zm9HDjtgxE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789726946;
	b=bjwkR+zyWEE+oT5wRk62SDYaWgsURplLuqA2eosnSeTPNntwNGTfDBd6A8+Ef+yN9Lp4H4
	xXsC+UZ0kVe+vsj31btgWKPEIE8OT6enWDgPRDcaeCbnNPAUo1nXPgHBWqAlzQQM3bjBNk
	3xEXMlOoQBVoXo1tEQ+I8Z7oFLVYnGk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20260515 header.b=oc0rbtes;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 91C5960A59;
	Fri, 18 Sep 2026 10:22:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EA691F000FF;
	Fri, 18 Sep 2026 10:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789726945;
	bh=sHYNy5wwK9fmryuUm9WuegCfsJ5nAR1Rndu3nKXnWCM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oc0rbtes9P5pCgieiV/VOaF4yxIo3bihzqlKgZzfBIMfnz2VHuU6zRiW4ajSUXtnm
	 uVE5FocXY1Yhiy4t8pnIJoR3/BnczzB9iCs51LhoCpGiksebj3Qt2pLRsukqoUpYEm
	 REf0NPHz8XkXAdp50l1exaR1wvGNu10DTsFYjcPy6aKz14s9a4O/je6de4IvC6GLg0
	 A1DaIKk9DyKxib5oxpK9DguKSuVOC9vs7GO3t+W6NbvNJEh57V+Ns6VoIsyvecixuE
	 bSGzwYp/Fe+PLbPTDSWWY8CwW7XXF44rEsII/FQ6ZPKK3hgeuSTBltWF4ZWzp1WTW9
	 X3l1tPtzei24Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 01/17] kexec: Fix CMA segment address translation
 with non-zero text_offset
Reply-To: sashiko-reviews@lists.linux.dev
To: loongarch@lists.linux.dev, pratyush@kernel.org, kas@kernel.org,
	"Jinjie  Ruan" <ruanjinjie@huawei.com>, kees@kernel.org,
	rppt@kernel.org, rafael@kernel.org, linux-mm@kvack.org,
	kernel@xen0n.name, dakr@kernel.org, maddy@linux.ibm.com,
	catalin.marinas@arm.com, robh@kernel.org, chleroy@kernel.org,
	ritesh.list@gmail.com, thuth@redhat.com, ruirui.yang@linux.dev,
	npiggin@gmail.com, mclapinski@google.com, graf@amazon.com,
	eric.devolder@oracle.com, vishal.l.verma@intel.com,
	leitao@debian.org, ardb@kernel.org, x86@kernel.org, bgwin@google.com,
	driver-core@lists.linux.dev, me@linux.beauty, mpe@ellerman.id.au,
	chenhuacai@kernel.org, takahiro.akashi@linaro.org,
	james.morse@arm.com, chao.gao@intel.com, liukexin@kylinos.cn,
	seanjc@google.com, palmer@rivosinc.com, pasha.tatashin@soleen.com,
	gshan@redhat.com, hbathini@linux.ibm.com, coxu@redhat.com,
	will@kernel.org, ruanjinjie@huawei.com, maqianga@uniontech.com,
	piliu@redhat.com, guodongtai@kylinos.cn, baoquan.he@linux.dev,
	sourabhjain@linux.ibm.com, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, mark.rutl@kvack.org, and@arm.com,
	mingo@redhat.com, yeoreum.yun@arm.com, akpm@linux-foundation.org,
	bp@alien8.de, linuxppc-dev@lists.ozlabs.org, adityag@linux.ibm.com,
	hpa@zytor.com, zhangtianyang@loongson.cn,
	dave.hansen@linux.intel.com, lizhengyu3@huawei.com,
	tangyouling@kylinos.cn, blum@kernel.org, tglx@kernel.org,
	jbouron@amazon.com, linux-arm-kernel@lists.infradead.org,
	sshegde@linux.ibm.com, gregkh@linuxfoundation.org
Cc: kexec@lists.infradead.org
In-Reply-To: <20260918100442.3841135-2-ruanjinjie@huawei.com>
References: <20260918100442.3841135-1-ruanjinjie@huawei.com>
 <20260918100442.3841135-2-ruanjinjie@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 10:22:21 +0000
Message-Id: <20260918102222.0EA691F000FF@smtp.kernel.org>
X-Stat-Signature: q6h354o618so8whw3zw7d4k5fxp4mc6e
X-Rspam-User: 
X-Rspamd-Queue-Id: 2DAF018000C
X-Rspamd-Server: rspam03
X-HE-Tag: 1789726946-955542
X-HE-Meta: U2FsdGVkX1/tTNx+wcu9pVjJu8qUJ9lQ+yJbumXQPT5XD5h/HPmV/uVuXst/gGp3EsQ+3r5hrsZtM9mjGmyFaW7CK2lxSuh2WWyPtVBh3ww9dYx3NOWUWU/MRSC2ASkqZ4DCHDVzsTH1+9FfMWrgQasJbiMxbqE8z4+xEigHnv32SCZcaCvrrDA9es2W56p4BgmMTDzV9OlWEBfUW2bb9zLqufdfbPIc1QT/hB+jHpcUKyjNEuE+KRXLt2u2MG0cFrZRmCS7cxRzkmDVi+43wfNqwhLOe53E++iCkpTOKOMfJBOG6N8DCfatLF86PNGqX47rojemgsz9ENDfwwg5YK/ts5uZ04VZ36zTssrNRhBInYS/USExAl6G1i6zgaALBuadZqs6Urw38x8T/KMVskRz70pfsb8JPh3+IdwXdgcExYOOtPT2FjIjHBvihx6Mrp+fvR7myDF6Srg2Yj2C2W0nSJGR8N58lOxw81Xonkplyh5zbLIAwhIZuSnBbVH3VvVL/6R01DS1YLi2TK+F/zIXYFeDDTDXzrq1tOgn0DZ8q6SGx1e4+BXijuw4ZMPH2gkeTOGZd/raqjOnomARWlU5JHSk2feuYN6j8tHKnj1Kih6hvO4IeYbZHcuRc7C0Xtli8Z2QF47d/WqKqMmFrPxtUp7u0t/m7fFGZnd/5shffQJ2M8dlqf6yQ95G4J6HF3qiI6efHpBioEkmhfRbq5v3PToh7oL4GQLlAHIZ4aKGJHRlWGsnq4QRg5Qh99v5hJMj64PpHDh8v9ZuJVxImvLek5j3E6mP4o7GAQ5WxaTpyE8xvWqwf8O8j9NIEKy+z2in9III4KTrNygIjjJ9So0Ui+kVz0NDF5hnxxcAitmeDIFbzbcsgvRVeiRorEX2npcLKtZhE2HBUoAJIMHzbIC8gmWfB8mwrqzlIAoL85AZzyS5TG6mowV/wYt2Aus8vvo/DxxWvZH9FsKUnLJ
 BuP2tQfr
 E3WIBGN7o2bbC9Yoz/GrThn2q1z1/I08+o8N+MuK+4a3ACgnPzHNRTxm+EeM4Sc38ZPoGsk9u2AsNH3Rvc50gBaVnQhjNXR5KIn7AUPQdA9vDqmQygEmg2MO1oQtzTeFGtUR8vg/53yR+UTrIuI85UrijJT0C6co+o7GGoM8e34/JJCLxOKnTsbHoC4ju95zCob6bZHiz21HJPGINGby0o9+cuKJs6UQ5Frj1B0bhlSUTrCrfHmPVzxc6eV/2gRn+sEFkUa88EfAoJyEDh5mkK4k8X2uU56v83HU2lUCjHrN3dfkzcOa4bAJTx6pSWUYY9YN1Me5323z35Y6zkZZu3RGzq/itOwLxATdodkvtZmEz59s6b3I/gXtgp0rSKZ4LgQVoqwSsriaGtGXXVGOdO6GaHh3ERTZlhnlUm6H+8POXF7Rjj+MWAYBEdW7cf6OGa/wyE2zCflU2+4qv4EafhVtYpPDG/73/+Isoq5hIDGmlOX0NlX71KhcauvPZKXqtJG7EqX/qZQEgTFBk+3WqBKLxdkjpsUokyLnjP/SSCHQ2YLHOsm/NTQIa438Ej7TNnET5dkKzOxxDeXv9De12Q9q3ZhFsN1JVJBR16qGJFAvNenM29Zpo7wkVcMpx/BeidV1tCxBhutI8nZPfc3Asn+BaUMzVbpZw9gPFhxUe3adDbeGF8COE/oRf9H5SM0KUxsHmb3r7jQu8tM7N0LtAzGk+08rXd+FmSOrcU0Tbbb9JEJvyBRJPQIB8mCdQMIYxlFeGIRs62qFzTv0XlNHtSAGv1wI5vfngOTkT3bs8JN4LWI/HUFpQCSKmnyHHQQyx3AunD0vDG2mslZatNM2KGOrRZ0Ox9X9uLTU45B02typ/l6nOqqL+S6nqi6HKOPJr81Q1RV29Y+cgGzhhp8wpZ3Zj0+vk7ZUgvVXh3nFGkwchbhODMPQAPY+6dGM/sY0MSjsLLkXJkomH/YgOt/YiS5XN8Z/y
 hwrXJOyP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> kimage_load_cma_segment() and kimage_map_segment() translate a CMA
> segment to a kernel virtual address with page_address(cma), ignoring
> segment->mem. But arm64's image_load() adds text_offset to segment->mem,
> so the kernel payload is copied to the wrong offset while image->start
> points past it, and kexec jumps into the middle of the kernel.
> kimage_map_segment() has the same problem for any CMA segment whose mem
> was moved.
>=20
> Add kimage_cma_vaddr() to translate a boot physical address inside a CMA
> segment to its virtual address, and use it in both places.
>=20
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Baoquan He <baoquan.he@linux.dev>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
> Cc: Pratyush Yadav <pratyush@kernel.org>
> Cc: Pingfan Liu <piliu@redhat.com>
> Cc: Justinien Bouron <jbouron@amazon.com>
> Cc: Sourabh Jain <sourabhjain@linux.ibm.com>
> Cc: stable@vger.kernel.org
> Fixes: 07d24902977e ("kexec: enable CMA based contiguous allocation")
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918100442.3841=
135-1-ruanjinjie@huawei.com?part=3D1


