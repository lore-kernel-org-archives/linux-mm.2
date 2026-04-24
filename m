Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 235C9FED3E6
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 17:49:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18C756B0005; Fri, 24 Apr 2026 13:49:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1167A6B008A; Fri, 24 Apr 2026 13:49:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F201D6B008C; Fri, 24 Apr 2026 13:49:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DA0F16B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 13:49:04 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5A80BC153F
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 17:49:04 +0000 (UTC)
X-FDA: 84694185408.30.1FCA890
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	by imf01.hostedemail.com (Postfix) with ESMTP id 118184000A
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 17:49:01 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=sA7gH+Fn;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=SK+D8ac0;
	spf=pass (imf01.hostedemail.com: domain of manuelebner@mailbox.org designates 80.241.56.161 as permitted sender) smtp.mailfrom=manuelebner@mailbox.org;
	dmarc=pass (policy=reject) header.from=mailbox.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777052942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=kQpXIVgVCV4fISNoHIQtgbvP1EXllhQ2T3mIJ8cRNro=;
	b=36xf9NKxDUMG94/mipu6rG28XwLQiawA3gbI0SFy2MGhdyL7DFP3WDRdBCVKYrlySeqQ5r
	jQn6ZF+TnpzmHNgf/gHdBA/4oCdHCmc97Ak2CSJKN2Txc6pZr+PlLsgtRLHjN9BtXgstVi
	evzMmmGGlWQI8Vp2xYTZbf4wW/F/nlA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=sA7gH+Fn;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=SK+D8ac0;
	spf=pass (imf01.hostedemail.com: domain of manuelebner@mailbox.org designates 80.241.56.161 as permitted sender) smtp.mailfrom=manuelebner@mailbox.org;
	dmarc=pass (policy=reject) header.from=mailbox.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777052942; a=rsa-sha256;
	cv=none;
	b=BbyDb8FNo74yQTFtND1pblr+GZ/KkeqIZCTVq8pNvQ/IhIRf8xN3AqIVVT4jJCdDFAPYme
	xfvjCLIaCFckW7x99auSisx36xTS8KzQ5AO21zmfmzUeQIRsjuRiqseKsP1lgANgaREj+N
	P0PIvuSGnB3CS5I3ZCyG9tDj6Hkaf7o=
Received: from smtp202.mailbox.org (smtp202.mailbox.org [10.196.197.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4g2L6x6Bt3z9spW;
	Fri, 24 Apr 2026 19:48:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1777052937;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=kQpXIVgVCV4fISNoHIQtgbvP1EXllhQ2T3mIJ8cRNro=;
	b=sA7gH+FngvczjarD1Tbb6PMFak20PWNxDbkqseniXZs+8QP3xpEuvgwReAG4J+PFdNl5GM
	b89YykHJSGUcM7lC+lgj6zlTdRk54bZRiaxpMbW7DfWoR7XLIuq9ezyqo70QE4X05H8N4z
	WK3gK4WK+HuJzJMh4Wsr86QsWnQUjLJr9+Mcic5BtOsW4+6zZbQfElWpmmVd19Rup6BxOF
	G4826WZgodQbSmk/vi7l8Sg1c1N7JG8djJPql/xtRH8aG84T4s1lkwHWLo/U7Tw1GGzEDi
	WrEamYqbj+UuOgCSj4UgnRkTId/5WRPnlzuuiHdKcMtwwz15Jpba+rHJbYgsvg==
From: Manuel Ebner <manuelebner@mailbox.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1777052935;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=kQpXIVgVCV4fISNoHIQtgbvP1EXllhQ2T3mIJ8cRNro=;
	b=SK+D8ac0yLSSdvohGV7owNyki6lMVoJQIzG6m1Nt3gyrX9dzmoQMlO2EsYgDh2KvmlR/3G
	Ky/jgJTC6EvnCq3j41LrqGLzTORmrqq3+msayHySfXLGg4ZAEccf05anBIXzoeEf+uMT/1
	fTzT7buEyY6zSICe5vhyLmnhOzFcr1WZJeI6x/8o9SiWSuGNcD/x9FmqjOuo1N2h9d2MRg
	Y7QJHh2AYZ6wOFgZHJ3e5gYExnb6+Z+GH/P6nPvev2FoJvAFxlcpuGJAtAvvj4BetjDjNp
	SGyH1RzYojU/NuSKy2z12Cm/2dklgBHerrwsnQqQ6kISt9SM9rxgx+2NLNL9cw==
To: Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	linux-doc@vger.kernel.org,
	Kees Cook <kees@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	workflows@vger.kernel.org,
	linux-sound@vger.kernel.org,
	rcu@vger.kernel.org,
	linux-media@vger.kernel.org,
	linux-mm@kvack.org,
	Manuel Ebner <manuelebner@mailbox.org>
Subject: [PATCH v3 0/3] Documentation: adopt new coding style of type-aware kmalloc-family
Date: Fri, 24 Apr 2026 19:47:44 +0200
Message-ID: <20260424174743.257951-2-manuelebner@mailbox.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-RS-META: fzthp35po1ukxbt6fwqeub7xbmjx4tas
X-MBO-RS-ID: ce45d6f12d0da57349b
X-Stat-Signature: dpa3683u53asi6qdcaaz3ge97656j7xh
X-Rspamd-Queue-Id: 118184000A
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1777052941-932692
X-HE-Meta: U2FsdGVkX1/X26eGtpn4ruISD9vXHC/ISxFjgwuGQ1uGnLXmbZFhF6ECy4KVeEKEHYnVWuFn8n/qSt2bY2JREm3OzJ/pY4wHirpUNhoKfpHmNxnOf2liYnysPvrsmevUmjj7u36I4AEd64z2I6635+V9tNYXt/7PVjCtgDRgSekglX6BMuBIzaesSZMN9aRCK7bM54coBRroVzyoWclOBR5f8DUaeD5S04TpmRJcCdLYLZ9mALW89E9OHZg0Adpsk9aGz6isLrwNbJPeW9Q65r1R3Ik4wnK100++pAyCqdavXAVhLvvKYip62pKhEBOdHqre/eSHUJAcHZN8ra0hjO2eE4pOFe6i4kzslIp5Kzpz7bpxpcwI2ed7WaTdVwv2QZcKSMvz4X3nIv7cOjJCP2Hzkn6ULSMXxBSf7/c+22LinqQeJZLgbosT3DW/g3utzNu16cKoB3RQnKKmqstf0li6yiCizZKOCGthwxqlDkdHsjvhLpIzXFB/4fr7R9cnf3YKsw7C/Y+vP8KW1ppepL5hkqFaLjzAk04VN9X06r+zCQEoCOMFnpiU9yf2PqC+rFx9d4MbcA7IFLdPkevjkNvh1W5LE0xhyJrm4PkDlUgcJRlFCFUUlYRPFtYal7v904xKPsZmBCL238kakYv9uDogVuEYh2ajRhEH2gdYiIg/aew7mvWZANjuWu+9wpujYRFFSXaIKUTn/WLBEWVFrleg9+dluVbQZtyr6y2zXFf9Rg9uMBGcqWMGg/y8/X+TB989aSsMcpXKh92vbeog/sSr+ptB93KQ7+jtf5WXfEvgakbfgivGr++QtLwLix+yl8OnQc+y4ShPx5BTKgSyfSEuAy28fj9E7rsdoDKVvcXW6PtQ6XAAn0LVypsmv1PDLwtsSn9fmHl4PVHi+hZvW4sV16hFCiZZqOSINSIlxIUHgnxmLqFC1BCJolT5+Z9uS0n1weJroEHTPyjrHKK
 ttWNEOhu
 8aFq3Gx9PvRWcj2ZTE8bz1cSG6HV5pBMnCN16qbHM87f0wjv1c9FHgOWbykeNCv5VM+x2mDSwIx8YKGmI/TzDyfd52di+tZfM9cinI6L3TYXpAEu1rNrzQh8qM0LBXmtcU3UtZ5rVDrsEHKGBgkv8Z77LgN/lITeMVB7Gg/vBYnDfIVRhg+r0mftqHHf5B4W+lDvlt295R9az9SEH/MsL+ECCJevpliXAUHKuq4u+1PXlhEJepf7/vExaBLi5ZELzvr7I591vxxIC2CEMHXUiuPeWQRfh6HiD+Du5kJw8Mvz27RbRYRl5HcecenrZbTHP7kfkkDBRhIaCqzqJxZW7tuDtNmaIzYlZQZ3z7BcxXuJjg1djnjNUkQSn5HvhY5bqY4DN6oiQ0OSfdGhLgCgeTOEZvfZ5mkftuTzOvzeG2EhII0o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update the documentation to reflect new type-aware kmalloc-family as
suggested in commit 2932ba8d9c99 ("slab: Introduce kmalloc_obj()
and family")

On Tue, 2026-04-21 at 19:55 +0200, Manuel Ebner wrote:
> I have also thought about adding a few cases to checkpatch.pl, but this
> will take me more time, and i want to get this series finished.
I can't do it, i don't have the knowledge in Perl and Regex.

 [v2] -> [v3]:
remove obvious wrong replacements in [1/3]
add Acked-by: Paul E. McKenney in [2/3]
change how to mark the optional argument in [3/3]
add recipants
 --cc="linux-mm@kvack.org"
 --to="Kees Cook"
 --cc="Geert Uytterhoeven"

 [v1] -> [v2]:
put RCU/* in a seperate patch [Patch 2/3]
Omit optional argument (GFP_KERNEL) as suggested by https://lwn.net/Articles/1062856/
deprecated.rst: change the argument gfp to optional [Patch 3/3]

Signed-off-by: Manuel Ebner <manuelebner@mailbox.org>

