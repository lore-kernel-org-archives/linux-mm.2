Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12FC1C982C3
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 11:47:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B4736B008C; Tue, 15 Sep 2026 07:47:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 241906B00A3; Tue, 15 Sep 2026 07:47:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 150F16B00B0; Tue, 15 Sep 2026 07:47:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E3B516B008C
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:47:06 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 809B41C2362
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:47:06 +0000 (UTC)
X-FDA: 85215820452.10.F099419
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id E8F6A180002
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:47:04 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QZ2fNNJC;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789472824;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1FXL4Jf8yBVgDdd94W09xM8udoaJZ5UUF8s2j4f47FI=;
	b=2GYkvH1LjQVCEdWL9R8o3KHssQS52U0peD9QpYboJYJPFCdarIOlWI6+eoOgEOUjMFHsrF
	NtYxZNIPZbrv3Znb9FiUenPdU3eYaA4JNp6lYpnmeYpypelFrNuya7YBqjlJO3r6v+2rbk
	AtEAjAjZpM2qJyO41lcjGkkBnq1bf0U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789472824;
	b=RmA+68/jG7t5/Fv94ymnvk2TAUzPnLWBs8QWnU8wIJgHPVY3FJOjhGM461qvLdhZGU6Lan
	VgePytsrL3JS0gxaowlXP/O93Z75eOSDRlLkYiUPsz7aNGLw+n9JXRW58zCrjdFYwxcku3
	SJ4XiA7u+LOQiU/ro+d+yait+7FyqnQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QZ2fNNJC;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 65AF9600D1;
	Tue, 15 Sep 2026 11:47:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C06AB1F000FF;
	Tue, 15 Sep 2026 11:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789472824;
	bh=1FXL4Jf8yBVgDdd94W09xM8udoaJZ5UUF8s2j4f47FI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QZ2fNNJCuZ/sDU9+NThrbq1C/6AJLSLjjYgkUbk/7nyMpmrJulfwzYoTCnnUhGe1L
	 CM809wjln9o8pUKvHaoaakBSdFe1J5tqURNyqgIGcIuV6TRA8iPD7jKUcKFqitGx8q
	 oytUrD66lpaS6duQZikdiD0MeK2wDhNbj/m9eIQI7ZfsqhvaTsVLdZ3ePpFdtQU9w3
	 reft3HQkQjN4ISX6sjFZlRkikFCalaD/JcuYF22HxwucYna7hJWQtoxtZdruPzMFDI
	 MwYt7lw+eOd2EaBTBnZye65X6XApTnuMpo5CD8CFs/K5wRHgdlLP4ZJrnz4u511/Ze
	 ZevBo3IdlwroA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC POC 07/50] csky: commit fds on syscall exit
Reply-To: sashiko-reviews@lists.linux.dev
To: "Linus Torvalds" <torvalds@linux-foundation.org>, "Christian Brauner" <brauner@kernel.org>
Cc: linux-mm@kvack.org, "Ingo Molnar" <mingo@redhat.com>, virtualization@lists.linux.dev, "Michael
 S. Tsirkin" <mst@redhat.com>, "Jens Axboe" <axboe@kernel.dk>, "Peter
 Zijlstra" <peterz@infradead.org>, "David Airlie" <airlied@redhat.com>, linux-sh@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-snps-arc@lists.infradead.org, bpf@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-csky@vger.kernel.org, sparclinux@vger.kernel.org,
 =?utf-8?b?Q2hyaXN0aWFuIEJyYXVuZXIgKEFtdXRhYmxlKQ==?= <brauner@kernel.org>, linux-parisc@vger.kernel.org, linux-um@lists.infradead.org, "Eugenio
 Perez" <eperezma@redhat.com>, linux-openrisc@vger.kernel.org, linux-kernel@vger.kernel.org, kexec@lists.infradead.org, dri-devel@lists.freedesktop.org, linux-hyperv@vger.kernel.org, "Jann
 Horn" <jannh@google.com>, "Jan Kara" <jack@suse.cz>, linux-hexagon@vger.kernel.org, kvm@vger.kernel.org, "Oleg
 Nesterov" <oleg@redhat.com>, linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, linux-gpio@vger.kernel.org, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, linux-alpha@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, io-uring@vger.kernel.org
In-Reply-To: <20260915-work-fd-reserve-unify-folded-v1-7-4d5217d6b246@kernel.org>
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
 <20260915-work-fd-reserve-unify-folded-v1-7-4d5217d6b246@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 11:47:01 +0000
Message-Id: <20260915114701.C06AB1F000FF@smtp.kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E8F6A180002
X-Stat-Signature: 1p1ghij4sfynsq1bfccms1w9m9n5mqmz
X-Rspam-User: 
X-HE-Tag: 1789472824-780200
X-HE-Meta: U2FsdGVkX1/me46Z+Nwa79oCWbWPyWtkFmYj48G30bMQamb1ziqhmnMOJ5D2jvRUvYeTV/keik+k9iD66H+GA2oDn60GXkgZKzaww8bmQ9sx+lhCDHB7bkuzjY0tcyIE0iDoaYNAAlbala51nPugL/a1E+JbijJ8VNAFBaoBasNezOC98cD+3m6atQHVXNQE5w4wk39ZESJ3TeOn53Yz1ggkk7x9zw0HSzFjIe5zdPZiWoBG75SVV2xa6SMwiDN7CKkAOZ61dVFOY5vqGm72f1F/CcCL587rIm7q+WjuBwb3UdIkuQwsd81byxJ0J9PYlaSjzfU97GicqAdcifl/38FR3/d3AKb2AIUGg9OiTz0FyRzYVdYVwNbEispVLwHcPA+p35IOXJYeuluWBOlekaFuHXMCwr8v9CmGbZ7xpl9r4SZTY9jWXLxYfdWmexkQF1zN9PGt211raXRuMuMAPS1FiR+w806yLTCRK4FsNHqi9UzFir8pS4iW15PJUqLv74QED88hfDqhMztRDFadC5eiLpx8XIgPKhbFEBoOSQ7lzrTFHgwiWSZ8+Nhpr6kA7LK0868b+AfW84eKSRhI6Jw0owS9MqLxyg2CNA57u1wupmq9mptBQwXzhnwYUgf7OEyswBCZ+vNboigMGYz85CFS66MmcOQcnf8zqyb/QpWi2NDABj4GyL/VMuavvaosgYxbJVYIPYoQo7yrGbPWSWg1xCByi5VWTVFoGcbiSrVS5dUXwRKFqwYYdtqzhSbV3i0WrRjVbz68RPsiBFDK75CMMSqVjFuKKSZKetu2HHRA9QnhniezprsOGTnxHOmkDEQxrGmjBOYgaPksU6VZLjFxCGCGwZhmYlnva2XNhZE0gXG1nqJYz5qrR8HdxetyXv+tf/yXksYLNTX1UYfTkX7cMzT8UpphhtMi76ffdFNdvcLKsHGCS8u6QkI54awBwgtn840z99p23MwvxHA
 xFNDF4eA
 /KD7EGTOUtL67NPZ6RQaHTndokSaKiZlfK3AIafBoKoUpnRjdzaKMJttGkCigjOE7ijMEm5UKZvUMVsNwwQ77LTvKyQi/xw+YyviLM7VT6lZe99FUUJHsUSshXgIj4sNJTl/wNIzOVzmrrpIqLeWSPaOUBMbV4H41z3teBPH53ucjbHwoM2DbDwb0iiGAgqDacZvB3Crzuc8ON+dniIFcaut0jeSEC9Yw9fHgTYjz0j4HXeDorKfpN/4EjzKbnkCLlJrS2UhWbx5X9fd5Jp7k75QK6Nc6g+/v5TOL6Rao0l7/SlhhrSGlKnY5BGcU1b/9qyw5ChN4FCNUBXmWrbfWmsiel39O4V1SgBsZqZU5m4YtnSl63sfiwQbynmKcVagBGYF/9nqx41uyywgdAp8w0DAXPDWoWGK0pzd6MLjnAjVPSFayVCvTEV64zypxfKfhkXyfzs96OwZUXX4MxzwgywDABRJMEOgsgMYt3H4idH42FNxXrNZDAdoq/E8tZYQAKx85x10bda95UdKljc/tzJca6cGDJEtMuqzn7XyvBultgBpUw5IooojwXu1KhWSznZJHu/pbLmGtD818MoKjxPxL+UyhsAoXnGugQdRIksd6qYuQ06dAy9V/VlKFUplGAa4joZboifoDcpk/r5KXNTDjtl+7wDzuBxecC40WRt0JZL8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Add TIF_FD_SLOTS and test it after the untraced system call has
> stored its return value. A task that reserved descriptors joins the
> traced path, where syscall_trace_exit() commits them before audit and
> the ptrace exit stop.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915-work-fd-re=
serve-unify-folded-v1-0-4d5217d6b246@kernel.org?part=3D7


