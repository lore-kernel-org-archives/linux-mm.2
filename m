Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB635C982F1
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 08:56:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF2866B00AE; Tue, 22 Sep 2026 04:56:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA2FD6B00AF; Tue, 22 Sep 2026 04:56:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB8D86B00B4; Tue, 22 Sep 2026 04:56:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 92BCC6B00AE
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 04:56:40 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 37F411A03ED
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:56:40 +0000 (UTC)
X-FDA: 85240792560.28.A27F87A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id A7A4C100002
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:56:38 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UjMMkTL3;
	spf=pass (imf05.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790067398;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pTlfKzJ0Vr6DSRpLT6CuScs/v+wf5LCST8fvQa+xTPw=;
	b=3Bm3Nx/udz8wXqa2/TN9seX/EMNxDehA5JY7OJphH+FZoMqxueThLjhQ68Zo32kGitbj4M
	eMe5iV5EJ045hrHTeFpc6TOhWk+F8TgGjvzT+wyWVZZXQoJszn0vfy79F2e8Zp9Oy55Et0
	JmHuM/IIqJ7ofIKdfma2BE6s8+K3BR0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UjMMkTL3;
	spf=pass (imf05.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790067398;
	b=5maNGSsfsdNSQf7PwbGyUJujkngXp4HdvrzSL6FsuAGpubOQYePgjubxh0zVEmQJYM2C2h
	HxlsqMewKQq92n+NUqOAVDosp+i67ZH0VWz+eLPo9DDCe8nugSu6Y0HilSonMEwG/xokjp
	urC3O2mRM+VCzVjzG34q57FOLu9ksls=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2D76660234;
	Tue, 22 Sep 2026 08:56:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 324C21F000FF;
	Tue, 22 Sep 2026 08:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790067397;
	bh=pTlfKzJ0Vr6DSRpLT6CuScs/v+wf5LCST8fvQa+xTPw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UjMMkTL3IajEia8updhKDn0B0sN4uZ+B51lBn49hz7hBmJ7MzWBYI5EcEuEfwLN1o
	 4jfNijR50BmzKGvcn4d3dOkVX34YzyVllzamWislCB7YlbrZGEahwe4J+IwHJKC6N+
	 1iHed7xRRr8Ru9DsDsXeS3ulEnbHJ7mRbt9vy/crzJg0ktncs3zhFh3LbWpiZPc+44
	 4UnH7475pFNCOVwqBQNdH8sjwnNDLUk/7fK7JR1SNGnthWoIVt6fcSbAzIpSdigwMw
	 lla9CdSpA7/mRiWzZ1SLBxmWzFq0xLxG5qwc+iTmamJ1wxAjXz1oC/erw2cD0LGg4j
	 xiUpRSRlL0knw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 2/9] crash_core: fold duplicated memblock arch hooks
 into the weak default
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wandun Chen" <chenwandun1@gmail.com>, m.szyprowski@samsung.com, robh@kernel.org, rppt@kernel.org, baoquan.he@linux.dev
Cc: linux-arm-kernel@lists.infradead.org, dave.hansen@linux.intel.com, tglx@kernel.org, will@kernel.org, bp@alien8.de, mark.rutland@arm.com, pjw@kernel.org, ruirui.yang@linux.dev, hpa@zytor.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, akpm@linux-foundation.org, mingo@redhat.com, pasha.tatashin@soleen.com, linux-riscv@lists.infradead.org, conor+dt@kernel.org, pratyush@kernel.org, alex@ghiti.fr, x86@kernel.org, loongarch@lists.linux.dev, devicetree@vger.kernel.org, chenhuacai@kernel.org, linux-kernel@vger.kernel.org, saravanak@kernel.org, kexec@lists.infradead.org, robin.murphy@arm.com, linux-mm@kvack.org, catalin.marinas@arm.com, iommu@lists.linux.dev, kernel@xen0n.name
In-Reply-To: <20260922084256.1515554-3-chenwandun1@gmail.com>
References: <20260922084256.1515554-1-chenwandun1@gmail.com>
 <20260922084256.1515554-3-chenwandun1@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 08:56:35 +0000
Message-Id: <20260922085636.324C21F000FF@smtp.kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A7A4C100002
X-Stat-Signature: fw7dh8os7ot9x1xym9pyfwo1n15rnwh4
X-Rspam-User: 
X-HE-Tag: 1790067398-196415
X-HE-Meta: U2FsdGVkX1/HnmbOAn9DJD1K21O2qN3HislvsRXoL8ih7vJFk72vYe44s3hw2THFc0rzLT0XKEamSbjXZuKkrkGejcjl0YESzbICefnj6Q1ZURyxchPbkTFbg5tIkRYdeh5vmnToREevv/V39S0wUyIKuT0fhw8Zfw+7WtwZT3U4LFoNRfi6pmnqUVLhnE0pUH2TUvKD12wkyDjOaZpqRwRgIvQhhzaIqkKXhFLeMbH1asJIo6VqpPW8Dm3UpOvnZm1zKM6Dd6C5Z+0LxKI2hQXZPaDE44Dy4vVywFxB3UtdyLShsGGRfDShOi7vkLSP/nWJ6ouKp/v41l4EIW0sjawjdwEQcOFEPnyoC/326DF85WCOM/mjvK7gHTgmyrT5VhY+7A52RNgFI0Hckj0votaxF2sPy2NMX9GX7hqVnd4Sj0GXnM17PNXMta9S/vab0HkTHEZvY9kmIzxRqZKEfPBxxpG0M7RUsjeAad+B7gTPSTljRL1dxGk+vI3jfzydWjzl5wTsTxFFxK4edPN+qjxmCdzOJ0iX/Td6glQnFx3cI9i4ENwd73r5AmkSVdDgrjWO+JQUWjH3AeLcFzjf184DUWljfYvvuw5NH6d8P/lVx2or7RtPGTr3OWLQrsTC4XVKa+OGj99CWMb3OLewxXX1vQgS+WaRRKMzZ3mF06GjsBE8pMw3jdJVCHybqEewsihkU++lAmN/DHul2GuG8IRQDHkF1LZVWLf9JHsFNsf/MZJLSkLV8DL3MLauKmjm+oFbb18iuMydGmWV7a0ae5RIBqB1NMdQxwAbI2Lo6DAR+txs2iAfEOMKYN7azuVYNXzMaIAtaEZ3QnK4aXKWFzoUDdTHTXbgY/4r7mVphL2LYhnszbmbI7lPnJKBkTKCX55U+4UHsdI658Td9Cq/HZ2RDQXqqil3hYKSRv6H9Vj6U7a+7PezYD9iqTFo7Spf8kHLKBPlKvAgJEVGpEI
 UCdapJUK
 UTYA1LUQaMeZUggyTHDGrM8uEmVtRSReMoqCk10OJjkWpWPrGEQ78jEGdynb9qnIOzL+GEf6E/i3DBkciVG9FHlZxvHopvkdU0P53SyjSf8rq02kOWMXA4O433GFO8SU88Q7319J5xBnNMnkEpUW/2dUUyskT3O+WqaxIF3VDiP9P62b2UColYg/wVvBZAuX9qwPo0d6HK2yTctAeEDlxcT4QmuOrm3UPRXDVWaYZFEGJ2UOYlp7O/R1EGmNuwvH1ZJz2+jR0XCFyweGYrNWVDT4o7/D/wu/JcCZFD91gCtUrs80RVL/yL6qRMDCh4S9pDvNobh8uU3y6QAifVcEPLHu7lSe5YfLa2PBBC0aKezcFz5kYv87GWbdX79NNktR3Pg6UWQ+MOO/4xmCC/XI2YqgskQOoLlO2D46rMyspGviPLdWGPYaw1Ty2eZRZPCdRqqhLUrCBaMCtfljoaeQVS1HR6UbECE4YNL9qvApKxV3KZqRsbaaXZYGaxLbPzzZpugo/eIF4yUvf1wUGEXWBmSwA9X1fhdostrQSYymaom/Tb9xJesdKSuriRFvt4E+GQiFJ38lHRBgu0VMjJHRSwB2cKMaVO79Izz//lCy+LshjWdvyVN4aGp2fEEdjHKsqnihsYhfzun9C9fBYizltJ9kGzQyFSo4dGlhY46Jv4D1CoQNYqmpK9diIM41TMFgseOKl7WnhMxhhAB8SWlD8AVEJ4IDzadxzAS4AR8RJLogqMbrYQEScmui/H2vRlzkVsIkXQvantp/3+EkUBE/5oDPfnO7WZhGaU+P2287xq61oQq5Qcg39Tvqihw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> From: Wandun Chen <chenwandun@lixiang.com>
>=20
> arm64, loongarch and riscv open-code the same memblock walk in
> arch_get_system_nr_ranges() and arch_crash_populate_cmem(). Move it into
> the __weak defaults in kernel/crash_core.c and delete the arch copies.
>=20
> No functional change.
>=20
> Signed-off-by: Wandun Chen <chenwandun@lixiang.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922084256.1515=
554-1-chenwandun1@gmail.com?part=3D2


