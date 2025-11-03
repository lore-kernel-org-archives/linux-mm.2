Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 495ECCCFA03
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 07:57:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A89358E0035; Mon,  3 Nov 2025 02:57:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A60668E002A; Mon,  3 Nov 2025 02:57:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 976218E0035; Mon,  3 Nov 2025 02:57:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 86B0C8E002A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 02:57:26 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 339C44AEBA
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 07:57:26 +0000 (UTC)
X-FDA: 84068540892.02.AF792CC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6F7272000C
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 07:57:24 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="EyuFXS/5";
	spf=pass (imf13.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762156644; a=rsa-sha256;
	cv=none;
	b=cdcQ6fHhZAuHQJ9TiCt53At2PHb6Vvib0VLkvd7JqXQUiyAhBlr2EDP7GshXoClDWp8RXq
	XGc9jyQkLuGgiY+qYGIFTWVkzCoECBfsHLhta7mAtty6i2sbOurLH4FsS53dUe9v6g3/WW
	60Q5s6CW7wnhS2bwq09c4gPEv0gb5Es=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="EyuFXS/5";
	spf=pass (imf13.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762156644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/IS1QnfToebO9Eww57EcVTgSVRHjpzRkmozpTfyGEkg=;
	b=bUnE1/u6PDyc8oqnfe6nkQSzmH+PKDp8Dhq8Bw7NB8cGvN+mZv3nnB9s70quWvn1iFYU2r
	6nwFUNPHkLVhyV3yCaOPMBqR3buH/yJHXfp3XQfLjAvzQNPz/ydq5lAPiY1RivKHXXjP6k
	8iL3WyfSeHON9qVjFmSC0SQk2227uTE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1278C4347B;
	Mon,  3 Nov 2025 07:57:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A78AEC4CEE7;
	Mon,  3 Nov 2025 07:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762156642;
	bh=HSj/Z5n0gDZ4meqwx9ffw43W8XomEOuc7B2mT893bzs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=EyuFXS/5i8cjPsKl1fmDKJwxtvpzPfkDrVD/7Dw9cVg4MIRSZ9pwX9Mwp3TkQNtyw
	 zoeqzLLyxPRNqLWKH6FXNg+6ZNo7vj4V4K1a2Q2k642McCDmgxisCjpK6A9S/QL1M+
	 JohKsDSLySE14H0H5z5GG8d356N9+qgQ55m+uwsMsRoTogFqUE9iZVhmwTsjaJxJ0D
	 rf7CiQwNGNOSkhhNm3a8Kegsyv/wACFQk0qTNci2kW/sBtJn3XjoC3JgBMB4DLxEd1
	 BxbJrOVgc9EcBq/f6dV64raqbuuFvwCKqXqgbvNuoO3N0Gl4d4KOsuqDiCv8HqbTcE
	 IGGXAlmxritEQ==
X-Mailer: emacs 30.2 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: "Roy, Patrick" <roypat@amazon.co.uk>
Cc: "Roy, Patrick" <roypat@amazon.co.uk>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"corbet@lwn.net" <corbet@lwn.net>,
	"maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	"joey.gouly@arm.com" <joey.gouly@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"will@kernel.org" <will@kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
	"luto@kernel.org" <luto@kernel.org>,
	"peterz@infradead.org" <peterz@infradead.org>,
	"willy@infradead.org" <willy@infradead.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"david@redhat.com" <david@redhat.com>,
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>,
	"rppt@kernel.org" <rppt@kernel.org>,
	"surenb@google.com" <surenb@google.com>,
	"mhocko@suse.com" <mhocko@suse.com>,
	"song@kernel.org" <song@kernel.org>,
	"jolsa@kernel.org" <jolsa@kernel.org>,
	"ast@kernel.org" <ast@kernel.org>,
	"daniel@iogearbox.net" <daniel@iogearbox.net>,
	"andrii@kernel.org" <andrii@kernel.org>,
	"martin.lau@linux.dev" <martin.lau@linux.dev>,
	"eddyz87@gmail.com" <eddyz87@gmail.com>,
	"yonghong.song@linux.dev" <yonghong.song@linux.dev>,
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>,
	"kpsingh@kernel.org" <kpsingh@kernel.org>,
	"sdf@fomichev.me" <sdf@fomichev.me>,
	"haoluo@google.com" <haoluo@google.com>,
	"jgg@ziepe.ca" <jgg@ziepe.ca>,
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>,
	"peterx@redhat.com" <peterx@redhat.com>,
	"jannh@google.com" <jannh@google.com>,
	"pfalcato@suse.de" <pfalcato@suse.de>,
	"shuah@kernel.org" <shuah@kernel.org>,
	"seanjc@google.com" <seanjc@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>,
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
	"Cali, Marco" <xmarcalx@amazon.co.uk>, "Kalyazin,
	Nikita" <kalyazin@amazon.co.uk>, "Thomson,
	Jack" <jackabt@amazon.co.uk>,
	"derekmn@amazon.co.uk" <derekmn@amazon.co.uk>,
	"tabba@google.com" <tabba@google.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>
Subject: Re: [PATCH v7 05/12] KVM: guest_memfd: Add flag to remove from
 direct map
In-Reply-To: <20250924152214.7292-2-roypat@amazon.co.uk>
References: <20250924151101.2225820-4-patrick.roy@campus.lmu.de>
 <20250924152214.7292-1-roypat@amazon.co.uk>
 <20250924152214.7292-2-roypat@amazon.co.uk>
Date: Mon, 03 Nov 2025 13:27:04 +0530
Message-ID: <yq5ajz07czvz.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: gwu8una37c8f5wr63qundh98dc17mz8f
X-Rspamd-Queue-Id: 6F7272000C
X-Rspamd-Server: rspam09
X-HE-Tag: 1762156644-726595
X-HE-Meta: U2FsdGVkX1+kp00fxTzzEZFhIGxa/l6/eEDSbs0tYW8bqJByZC2FvJJ0h94oN9+xo1o6p66Ak1KS8UneelIfgfEBufhhEAEcv++Ga6iuaznjX+yAqfyPgM/6hNkryhM+1u2BX4GGQN6YYhSk9rBnxcAQO8AYsoGaHQbcx24NOpyIJjFBb4uwvwPdg8/Vy8ltTHaarofnfFQwNFT/6lHhovKzdlXVBsPNmByWOwEO1tAL/7VWqNfgX+A2LR98vaBG8DHcxfbO7GfgRnXaeNZA1PFP6MYPugYycEiUQ8tCNowE2x4VZtDrGwIiRSfydA/mEH/0lbA6ALdC7xT5oBf+TkpqQMjLXO4JmciUmyaAkbCXMubgTbBJ0cpZLcoIhoV4kXg9ZDL7KOFz9uzkgmaMuD8UHRhej3aUSdXCXprkYihLmU0F1CGeKnfmJDGsAnppO2BiGGc0WLPzfYS5K3YymubSGtSgZjRR9bA0b5M5ps3RLdw4PORHOVqNR1xvlg36mWa0QwVuZYnLDTEpc/+uUdaBHZ1JHG6cfwvbvIW0BEKZ3vEH2dt8LRajrayfKwJmXRN+zJC2zTi+WxJ5qfuHu45cbbIrwdRyDihEJFJ6sGjJ4SNjdD85HOanMTzXKOyW3HK8CcldWZe3VxeIL2gsrRjpkrBMQM2lSjq0pN+2Q9oqdfdckg7Zzxjx6jhnTyciuiTjRavyTWtb43PhG2co0TwHyHyWb8cyZ2bq8+11L8M02tPNnwHT4jo9mIylS+jsQJZYe26fKijpwTZkcCCY7kqzAgFdrS2YNSjTU30pNI4IBFvy5OoTnIp4YRjDHltoxUBfII6j2iQrBvTfxAjbYaQYNYYILqNiQDtD7GNpp6puAvwV9JtvGkBFLfg438998Og2CMY9CBqGH+LekMqqXJ4V/KJTekDbyt+Y4fOFEzGb5LtZoTur3jbBlr/tEz56HovpBQgIqFEVlcGejyP
 yH1kVD+6
 ugaOc0Gaqs9bZ7HwzvtP06PLtv8xqF5lwSLV93v0r+U20XK73T5yLBn81xplwpC7su46QsptgUhuj0+QyVTUBiJEsS53CgB+WSTX5+Jnfy6n38BvURfUcxEolzx1O+q5CslsqGlYQTFv+z7cO49qQVBTVXjqosa8rBPc0OzYC8P3hndElnejr2MPIltgruHvsXt2ZfVMSCD8PeiwtSsqNP/1D5aYOPpDrBHC+aeLT2LJ5uJiByUkJBB2PoCHnF+FAPph3YSvv6IFtKjxwq24ZZsBK7AsaK08ON3BO7m5NnV5UQo1VWRsNbPuO5tZ7ImAHExO6DTgZjUm9keITEhtIhiFweGTL+hA/mykF2hmD7ic+yxy3/5y2M5sjbhRMxMTBqn1vu+KPGO6vEinjiXXJwmr7/g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Roy, Patrick" <roypat@amazon.co.uk> writes:

....

> +static int kvm_gmem_folio_zap_direct_map(struct folio *folio)
> +{
> +	if (kvm_gmem_folio_no_direct_map(folio))
> +		return 0;
> +
> +	int r =3D set_direct_map_valid_noflush(folio_page(folio, 0), folio_nr_p=
ages(folio),
> +					 false);
> +
> +	if (!r) {
> +		unsigned long addr =3D (unsigned long) folio_address(folio);
> +		folio->private =3D (void *) ((u64) folio->private & KVM_GMEM_FOLIO_NO_=
DIRECT_MAP);
> +		flush_tlb_kernel_range(addr, addr + folio_size(folio));
> +	}
> +
> +	return r;
> +}

These 'noflush' functions are actually doing flush_tlb_kernel

[-]  =E2=88=98 flush_tlb_kernel_range
 |-[-]  =E2=86=90 __change_memory_common
 |  `-[-]  =E2=86=90 set_memory_valid
 |     `-   =E2=86=90 set_direct_map_valid_noflush

-aneesh

