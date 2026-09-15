Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F69AC982C3
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 12:02:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6510A6B00A9; Tue, 15 Sep 2026 08:02:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62B406B00AA; Tue, 15 Sep 2026 08:02:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 540796B00AB; Tue, 15 Sep 2026 08:02:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3B7896B00A9
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:02:57 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D2AEEA03D9
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:02:56 +0000 (UTC)
X-FDA: 85215860352.02.51B2B27
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 26FAD14000D
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:02:54 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DfQU5nin;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789473775;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DKmKc8nUgnveY4UghGsysLXcnr7yvrf1lajtZ4j0caE=;
	b=GE6GAeg59uX64+q2Oz2nDFDSAbx9GiWto/OezH3ujzUII9m/kZovwRYRjmeXRtR66g9vFj
	cUdsQlu0JC65C36LPSGcA4UIOSr4M+EQwxH/XddcQlOfLLbuvoCzDGNSHUt+q/XnAv51+I
	qeDeqh3Icmj6l1QzadjYphv8CvY04A0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789473775;
	b=xFT0GyrA9555Fi5gk4C6d8kv/mR6JIU4jI4s4ewaelAjVBy5Qena+//aMKBhKvPAUSVTV/
	3WIkW3wDKU0n83XYRY3G7ho3EIl84IXXEN7KNW0ROKmY1XnCNOjJGgSbLo1Xq8B4xpzKVJ
	yqEBKZ/4EUU/o/qPcHQZNESrLF9szZQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DfQU5nin;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6B76E41687;
	Tue, 15 Sep 2026 12:02:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89A091F000FF;
	Tue, 15 Sep 2026 12:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789473774;
	bh=DKmKc8nUgnveY4UghGsysLXcnr7yvrf1lajtZ4j0caE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DfQU5ninsS1IF1iFmSCoi9zf6HJdPuTsj7XVVosHw24AZzhEXM7lUTSHKfoNPHRdo
	 ftBPV2UxXZ2x35Xuh5jkFihXtOZzfFYSs5oMx5CREjLOMipaTe8AZXg3ZWUkHTE9VL
	 3gNhL/WjsyOkNox97h2tfNc5eOHIstmUUtbf7Kt7QK0dzF9fCvXokT4Z7qzy3LnalW
	 L8pIgSgRVoLl7LNk9qv23YKEL97Hvnx60zhcjswEXimdWiH3nyH090Y8Tjh1FGnAql
	 aHkyZipO2f+jnmDQAYZHAx+8OnX8dq3pE0GKnLcYYqt6qe+Wm21ZPjEtaRgeSDex2F
	 1fIq73PDJ4NnA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC POC 13/50] openrisc: commit fds on syscall exit
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: linux-csky@vger.kernel.org, io-uring@vger.kernel.org, "Peter Zijlstra" <peterz@infradead.org>, linux-snps-arc@lists.infradead.org, linux-parisc@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-sh@vger.kernel.org, linux-openrisc@vger.kernel.org, "Jens
 Axboe" <axboe@kernel.dk>, linux-mips@vger.kernel.org, "David Airlie" <airlied@redhat.com>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Ingo Molnar" <mingo@redhat.com>, linux-hyperv@vger.kernel.org, "Eugenio
 Perez" <eperezma@redhat.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, "Jann
 Horn" <jannh@google.com>, linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
 =?utf-8?b?Q2hyaXN0aWFuIEJyYXVuZXIgKEFtdXRhYmxlKQ==?= <brauner@kernel.org>, linux-arm-msm@vger.kernel.org, linux-alpha@vger.kernel.org, linux-hexagon@vger.kernel.org, kexec@lists.infradead.org, dri-devel@lists.freedesktop.org, bpf@vger.kernel.org, "Jan
 Kara" <jack@suse.cz>, sparclinux@vger.kernel.org, linux-gpio@vger.kernel.org, linux-um@lists.infradead.org, virtualization@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, "Oleg
 Nesterov" <oleg@redhat.com>
In-Reply-To: <20260915-work-fd-reserve-unify-folded-v1-13-4d5217d6b246@kernel.org>
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
 <20260915-work-fd-reserve-unify-folded-v1-13-4d5217d6b246@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 12:02:52 +0000
Message-Id: <20260915120252.89A091F000FF@smtp.kernel.org>
X-Stat-Signature: tq4rmmxujb59cwouoex9a918nb4dotei
X-Rspam-User: 
X-Rspamd-Queue-Id: 26FAD14000D
X-Rspamd-Server: rspam03
X-HE-Tag: 1789473774-467980
X-HE-Meta: U2FsdGVkX1/VKlkGAYWO9yCu7SQJuFe1fl+KhfkLdj33LHGQjvqu6t5ZhZyVSr9GEvVfcoCjMliPT4U1krvZG6iIC133G4MOnHHoLvtwg8wyFJmsmE+hVhSPd99D5LomZbYHKdzPz02+C6GrjqZeV+rfCFudCinCUFyMP0pVdAPilZk4Ju5rLaMRfvbFLRp4bUb7JLbBzdzB80cc+yZzEhHJplB8Qmg7kRaSSYG0mgjqZ+aiKhIbSg3Sj2Auea1Xn9twptR5V2yEyneSmGIPYTt7uJNjdKQldVQLAfwEmlB/Uoa6JIUcUvHZ/vTitwD7dc3G7FTcUG1oY3M43mpcPi9OEX8zwpa88A/ECQvdqPha3YqrDoPWmWVExHFa/9MFNzCBtk/huE/NTbRiQmfeKznmvQKq3eV2FXulWzB8bzYuh9gKDWPr0fUtpSk0E8r7q6y9z990J3gdxZr/RPzZiUQG0VHeCVEWlR9jQfQ7RYFrPDHVUcd6btMl9y8UwzjnY6iOYe2HkUq56EwW0cdMIqEn5VeUZW8RAHCmowVr9HYJa+DsemxA2ieYbf0U9broIMG+Ft6EHkbpoE/T2rhHkvCD6PM7ddP7uzCVyy0ciCBPwQaLN9aOavVCHhjEhhmWqMQovv7H14R3uuQsxRnBp9Is4GpYHKvh0KneLm/6SyQW0eCalH/3TxK5euHs9LFETICd7S70F+tCuGxXYnidgI1S1bD+/vCSFZrdYQ+6p5MSpCLU3/4m9sNK52nZ+MY++FKH7y+agR9Jo7AfucXBY4mmuXaRPv5wFpcqnNXlKLW7WklFQEFL70dNQUFJraLtvKNXkJlcUbopoR9RQNokNSJklUwGNHMiK306emOAeGovOLq98HnXKrbcTszx51arddKTLUMn7D+dV/77j77FAKzZja0ekYxs0LSjCJ9AxmNwKSx4AmCJzJOlquxKH3AR3ISFUK1L1y0EJo+VNYC
 TPnqV49u
 2wRZ8RZ8ENr1W3Q4BPr+DyFFq7oJ7b8zu8FAXv+pctyyI88C7D9u4MJh9fYmmlHcVnuyuleH31RS1ghipFALKe+YqmFA001cKKaf/HCcc9SpMexE7MDcq9ILCpzzbqldB6NFzcbVk78YZFQSe0sIfEHkJuDn4d2Dp7IDQLy4qtYC5tyIDZ50VSLAhmd6DpBDrK0Bd2PT7iQxbmRhgBty/wdqLrZOd83c4JIdClawjjdFjg733B/B75eFf/JM5NBQ9Yehfn45uijpzXyFo7WPIseqXrvGIcyJVMi8B4HmL0fok77ikjbGGQjSfReqEMcTFbbOZBjUz+YZQCsthe4ktIn9HBNO+IgBMedY0WwJupuc+nL3pQxGN5xfhqN/8VCJVMMPrnKzz4obdbzzvPYe7uHcEFnSBquoOODX771G/PvYfWw6CRxkv+GToyYjQ2p4hQt7pektC5jRISyiqv3jvomZw1nsLSJ5WzPGTvrRK/NVVb8iccMSqRfon8viPoLJLcCMcm8LByQmobg9NKzjIYCuYDkKIX8iKyqXucrGS0MonTJmLbLCax/yyJfYxP7pO2qoEz79F0wy7y0206KJlmxlmFO/g5kD3/4Nyw/9yXBnrCr6O/vgL34BsAGZWaCjQwRyg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Add TIF_FD_SLOTS and test it together with TIF_SYSCALL_TRACE on the
> way out of a system call. The check used to rely on the flags r30 had
> been loaded with before the call. Reload them. The syscall may have set
> the new bit. A task that reserved descriptors calls
> do_syscall_trace_leave() which commits them before audit and the ptrace
> exit stop.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915-work-fd-re=
serve-unify-folded-v1-0-4d5217d6b246@kernel.org?part=3D13


