Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAAA2606A323
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 20:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F2pk+jG4
Received: by kanga.kvack.org (Postfix)
	id 91AF06B00EF; Fri, 13 Nov 2026 15:32:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C2766B05B1; Fri, 13 Nov 2026 15:32:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B1C26B05B3; Fri, 13 Nov 2026 15:32:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4F8B66B00EF
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 15:32:56 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D27EC1602AA
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 20:32:55 +0000 (UTC)
X-FDA: 85431244710.23.43E3B2D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3241E12000A
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 20:32:54 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F2pk+jG4;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794601974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7kGyvkK08X7x1lT2uCcH0FMHoas2jrbCjIylRbFLUhU=;
	b=ea3eLeN6ZNANk0ZD4FimQ+PbuzqSYhb9uYJeJqG8AFiDUr2XanLN8+f5/QcNtOcYrpj0Wn
	p3wfFhLSZ7QRNacnO/CXZgESmArtfQJ0dEMtfoV5e+IEGdCxk83mspzF+j72AT6upE+9c+
	1UjRlB5BNpaj4vn9ozSOet/I+bfwDoI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794601974;
	b=7PJOYNROXaGcbjnG/IyBYI7GPRvbVEd5gEe+PsaRRMHz2LCBcstSfcPG7OzZDYba13qQ+6
	BwtifSb2oclqhtZvdMMd5TtMJplHdepYkuxIjLkGtGhk5vvJNuoFg7gyBJujEpTAlL/uxq
	Ix6cLI8JUvIqEslg3KuOtBg2hxib6bc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F2pk+jG4;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A56B062389;
	Fri, 13 Nov 2026 20:32:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6156C1F000C4;
	Fri, 13 Nov 2026 20:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794601973;
	bh=7kGyvkK08X7x1lT2uCcH0FMHoas2jrbCjIylRbFLUhU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=F2pk+jG4qUvodejQG38Pf9aLunFm0mGPRbuZwJxDgkyHq7jOf+NJX1i/vtDIatCPf
	 Cw2NBFZtuONe4xwLRjLZQQviA5lPwdhtGZgKNvrguufJykmq95BoxszydeILAPgPWB
	 vNYGqGq/D5E7LWSO7AagLb34uHE8769m3fs97xzHZdS4tb5IGuw3M1rwA86XR+4fYP
	 NwnwwvzQ8Je8HFhReph9Hnq5uE+AvFEGZUEhJZEdJyfr8Qsjv9d1/ZC0SGtQqk5A2f
	 p5qcpnnvksMjDPjc48+mt9oxd18LnMfhIY366tkaJk/nfQW8WEw1Ut6/id++D3wz6D
	 fQqI4bWU6FDPA==
Date: Fri, 13 Nov 2026 20:32:46 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Carlos =?utf-8?B?TMOzcGV6?= <clopez@suse.de>, kvm@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, 
	linux-riscv@lists.infradead.org, seanjc@google.com, pbonzini@redhat.com, 
	akpm@linux-foundation.org, peterx@redhat.com, imbrenda@linux.ibm.com, 
	borntraeger@linux.ibm.com, frankja@linux.ibm.com, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>
Subject: Re: [PATCH v3 0/9] KVM: don't zap secondary MMU on permission upgrade
Message-ID: <avdzWA5nrPLoIztq@gremlin>
References: <20261112142039.907090-2-clopez@suse.de>
 <2ff19317-8da9-4014-be04-27fc218b8eea@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2ff19317-8da9-4014-be04-27fc218b8eea@kernel.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3241E12000A
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: irahy99sqiehb7fdcupjwfj7cacysjaw
X-Rspam-User: 
X-HE-Tag: 1794601974-29700
X-HE-Meta: U2FsdGVkX19A/9GU+Wn0eDcGNhoft1xln/paFyrGLfS+r/kIKjGMXfBBJkstMsyVy5EBX0IuQQEpgeCa0EO7JX0nYuUpdE5x7mb+7qz+Vvst5H2GfzkWNUpOxaF/F+4cqN5wRnKhRQa5voEuF1DuckoZPU2S2Go1S5gGID4qtOHMmje+sR2lo2aDxYFeOpqH86R/ke0BB/MKZhAflPbRNnoNQNsOlo7wOHiNML8fWqcBC2W0I/cgIvCQj0jcfNoQOQTyV4BCrEXDVlUYOyfZ0yhGKafeLvAhzawC0A/jWMB8SOnrA5y0enoybUwMQzr8LgIU05e7r2Ut2otWjJ5sSeD866m71iR3Bs9g1bcYJMTraw/ywBtUOSMZF2EH7ELfvIoe4OHX4qxG8o5amKNC8DalP3ASwg8NeC48U2lmX1+kWG1UUsamYpsOiYnqZ0J/ofU8KlEX9m2IU2MR6WJQARu4VMKJEvqfjEEiuhzujgyNVy/43cYWCAA+3cHuhD9RhMUnzDujXwAVTKstxiv7te7oMTyT7Rm69V2TrQwVa65UN/+GVGKH5z5SgUMli5ZxyfhVEq5DAbBdnJNbNLMs3BeNTpFteXSGX8W+eQo1E+VQJqeLJMSrMmXM1ltNzPvu8KXeWlXvBO4L0VN9UWMKrFrh2vJVl6u3hOUn2im5IBSGenmJn3ogxs8Vv0M5m+PaIgJ+eWpGh7nOp+gUf5tV+skVc7g2E8QJ7EVEyc/PB+Vi41aihAiT/L0I5OMjVmy4ftremOWJb/LrBoYXhNaAEwa/vJbYcMbdODXcvZDSHW5q7q60G1/w+BhS68hMjv43PDE/i1ZBYfKGt+7owRmQYSHTB2/1k1p73oX5EfqIB/Ad1BbaDV73daMgAR2G8uVxKWm+XsD2pmhgH82uNVEeIrPE1XG4TSVVOhxhmrjKRMOAmLXXgtU4bNHaqPPulwHhSk5fmFBlv8WJxMYExBK
 B92oi0hQ
 XY+dqOLpp5MsUwegC1U3oDSq1dPQSTyK5UDaG0yMRTLlO+375gNrd79w3BDxQZRLfxxHfKjzw1GzYHUoo2zR9ltu+zvvoAoxA2OB4jNYG4H+jjrf70hUZHK2eKIKCMFCBLWL5iZ7hXqewHv+TiaYN0QvEeX90sgsyevu73LitjZKBJu5rbWDZHpXgOnfRZ7nS9nVeQhcGhIv11KosMFrUlCMxX3Szaa8aVgmK4v2zYjNhoiqCq4NVkt8Ar5YirpKjAK8Oy+YqrKeaGTFm1jm9846x7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 13, 2026 at 08:00:02PM +0100, David Hildenbrand (Arm) wrote:
> On 11/12/26 15:20, Carlos López wrote:
> We generally don't add performance improvements without clear motivation and
> data to back it up.
>
> MM is currently busy with more important stuff, so best to keep your changes to
> a bare minimum.

I'm sorry after what I've seen from this series I'm pretty convinced it'd need a
whole bunch of revisions, and we just don't have time for this kind of thing
this cycle.

This is v3 and I already want to NAK it...

--
Cheers, Lorenzo

