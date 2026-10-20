Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BFD360A5BFC
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 08:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FOoPCDk9
Received: by kanga.kvack.org (Postfix)
	id A81F46B013E; Tue, 20 Oct 2026 04:25:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A32316B0140; Tue, 20 Oct 2026 04:25:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 837986B0145; Tue, 20 Oct 2026 04:25:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4D0566B013E
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 04:25:53 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CA25914086F
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 08:25:52 +0000 (UTC)
X-FDA: 85342321344.24.EC18A89
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id C46661C000A
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 08:25:50 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FOoPCDk9;
	spf=pass (imf20.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792484750;
	b=FZBuQVuErstcNH9qkskNGrqotyvnUXv2ciFZooPnrh8IbwLizu8OjACPn3UBDpXgh46PJR
	0Z3nBt+GxhlKAJyW31YDEebo+q8m1BrMqiAQIMo1OS91Ng3QoIpsbDzg+ub3R/pNaohCeS
	X4+Q1gzP1JeD+nztFAnYxA98HkGJuwQ=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FOoPCDk9;
	spf=pass (imf20.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792484750;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XH3G2A7GvTP/8THrs95qFRMJKqXgEWRG0Nu2DxafnUo=;
	b=7/qq4/npNX+SLluwa4iznSn5qdv04qCkrepubsVccXCr/SsCIMQQe8/Yka4YKkAESjMfhl
	JJ6CQWoIFF9gQYt6N0JGjdO08UpWCbZlFIshe+nM8Wadn7SIQ5w/U5d2ReY3IEPkImkofg
	zdDC+neYV7N3n4ZJ8eYNyzejUPdLLuI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 646B260DA8;
	Tue, 20 Oct 2026 08:25:50 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792484750;
	b=vFR9lBezz2eRygNB6k2yIKrBNOXBIOQl3bmVaUL0QcnmAQLHKZ5RHoeBzKmIoN3EM7WD
	 U7jTRpGdhTgHK2yvqN2CrK2NuN0ZFSgMWf5GKFKiKXwFctxG4XJsJ99iVUV7HEbnunErD
	 m4VAPNj0nE5D+nZMpyqAAd1idNG9FF6lRKdmutKP7ple54IpKUcO/37yz4ChoYAkTuHg1
	 /apoouVx2+a1xx00rDaVO2AFJ1Z0KrgQYtj4Kql1a2Iw1Ex2IGWSSkCyXXmzxIqeSeMVM
	 5Va2kTVJ5mfVwIfaRJ8HmhXO80UUeoLaZsUA7ZUJydElbav24VU+uKJXotdRKIhUjkw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792484750;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=XH3G2A7GvTP/8THrs95qFRMJKqXgEWRG0Nu2DxafnUo=;
	b=Tayb36gh8myaj+EGWsbkQBdtX9Le36csgTtOgxVh9jC8vLazetu+SlcwVqG9odP+p3GO
	 EyGwsHPTW7wQuuP9esd64EvTvog+EZrIYU2Yg2f3zymEkj1X43E2F/XPQLQNwZIR2k+Y6
	 x52x8uwDgspsETS+kie6odixGseXMlphGu22uCEyM9v0NbX97vv2HXIWlPokGdNloLPjl
	 /pgKP75etxltccPQMemHkaQ0mzfdk3NTump4UOk4oevrJ1q8AfS6azvfQ8AWFsYA3VGcX
	 qT3UNHtS9p1mv3zeuC823Ci+1ydMZA9+PLmeQstIMovJTmX0z0NZkYEZJAK8HXiKyRA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 454001F000C6;
	Tue, 20 Oct 2026 08:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792484750;
	bh=XH3G2A7GvTP/8THrs95qFRMJKqXgEWRG0Nu2DxafnUo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=FOoPCDk9PzDegt6Ndt3/T661sc0aPvg+kg0CDgIGE0akL6hmy9hiozw2sF3tlnUk7
	 js3SKixbeKTvTfNMSOtqT/Zyvfpjqp/6LgRM/LkmzA9sA++W9niSL0sWy7HZypceHH
	 dPrkw7eAaDNCGY7pJw+VMswkN413HPB2QTGCbHl/mP7fx0C9AdPxWmCyfRQQzYrAdU
	 XadcvH2Z/qj9r0WgTC5LPsYk8bZwWEktSES58tKxNb28NdXfB07zoMNn0zUop4vIJ+
	 s/MXWAYeg6K0Eyq/3HgjFT7IixTGRmqcZG2l8ajUutvW31+Nu4AJdjgyhcFjzfuAJo
	 9KZhlP08kAQzA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id A81C4430D3;
	Tue, 20 Oct 2026 08:25:45 +0000 (UTC)
From: Ke Sun via B4 Relay <devnull+sunke.kylinos.cn@kernel.org>
Date: Tue, 20 Oct 2026 16:25:19 +0800
Subject: [PATCH v4 02/11] rust: mm: add `task_size` helper
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261020-tyr-ioctls-v4-2-704de77da223@kylinos.cn>
References: <20261020-tyr-ioctls-v4-0-704de77da223@kylinos.cn>
In-Reply-To: <20261020-tyr-ioctls-v4-0-704de77da223@kylinos.cn>
To: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
 Danilo Krummrich <dakr@kernel.org>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Tamir Duberstein <tamird@kernel.org>, 
 Alexandre Courbot <acourbot@nvidia.com>, 
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Lyude Paul <lyude@redhat.com>, David Airlie <airlied@gmail.com>, 
 Simona Vetter <simona@ffwll.ch>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Sami Tolvanen <samitolvanen@google.com>, rust-for-linux@vger.kernel.org, 
 linux-mm@kvack.org, dri-devel@lists.freedesktop.org, 
 driver-core@lists.linux.dev, Ke Sun <sunke@kylinos.cn>, 
 linux-kernel@vger.kernel.org, Alvin Sun <alvin.sun@linux.dev>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792484721; l=951;
 i=sunke@kylinos.cn; s=20260317; h=from:subject:message-id;
 bh=JO+2MVB8/0ZEX96oFL0eP1mAOKrIibNCaD5F9FcB8NY=;
 b=QjR4/KrceM/lUJAWh1u5Li3pbdAeeC6usQbh1gPSp0AqYQSUbTxeaip2u8SiAsBDhfe3eTckS
 EzCvxT85ecCDWUZf9o/aQBSCiml2dioBcP5kuQUiKmf8Qu37HyuvpSh
X-Developer-Key: i=sunke@kylinos.cn; a=ed25519;
 pk=CHcwQp8GSoj25V/L1ZWNSQjWp9eSIb0s9LKr0Nm3WuE=
X-Endpoint-Received: by B4 Relay for sunke@kylinos.cn/20260317 with
 auth_id=950
X-Original-From: Ke Sun <sunke@kylinos.cn>
Reply-To: sunke@kylinos.cn
X-Stat-Signature: wy6iert153au4xdprgjneg91ekpzupa7
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C46661C000A
X-Rspam-User: 
X-HE-Tag: 1792484750-727969
X-HE-Meta: U2FsdGVkX19FDAVyXpY6fufyy+tAUmW/mDkFofhWmmDaHZhTcPB3s5t6ecHMZsIxpE+TXFV0KN/8uGax3rvKfSPrgbHN/mi4z3dc9WFaP+Et8og0A+tAOzzIdOgoBWEmkXj+VltLtm3r5MX8GMxGkFs5nm+5P6pv1lMsDJETfEcb2EDp44W7XyjBZQv6YmXTNWV37E232JGVak+RSGbwnEgbTQn3WqOUw4nWDcpRBfp2un9o7DrWje+iCPxTKfv2yygoxb+yVFj16/nT/nxQ5iuSopAU3BnR/1h/sBzLjjFADjLuKBF+SefsqZTdFfEDQ50GnIDnzO39VZYmZ3J/Wqd8WTppKT/i63yGpt664KwBV8YvpXT/nkV/SpjVO//oo01xrOgRSVFv8vaO2S3NTUxUr96Fq6mEmUHTiRbgb/91bB5VnxhFjdnskR/IXPo+1u9E9XNK5TE7n9oC+WBTk1TqTCG+lRXak4oDkQl2ODYCQGS2k7o86X72YeHmUnjOpuVHizdnZ41GtBZiYEBYdJFMPBey0K0ZW+UCXM4mo6xtetD3LH4R4L/wxt9q1UkmmcFe5eLNkfXpGhzRvBvALRfkDIUbrQL21lLg1aLOJh9tQ20swelvWh6Gduh/TPNmyUiSg6kLwDzJR1G7EZDoP5mkj/fsuu33JfW4EqEhcV6k68j6DbeY68sTy2Eo6+5pShp/VaP5+NLhfxWx1mxPLCkHF7P4iQocIXpfG5Ei40snDqroIN/U1DDXYPbVum7JjpBgDJWc235zjFcvFWlbPlLMeFB5svsJSzbUrVIuRQ6rCMUucZffbz1T/FGtpc4Kwoc8i2qwgPdQv6R0ar06lBI2Es7Grox8UeprKfUfDTNEjHQGpsAUOu8g0sUyrxOITHuprQn/bgJ5QpZkHt2W2lIT8pJFpMiJTH4jUtrwTdEly+bDoP28TJLE/9v3lH6muIa6r3m7jxZ6BSr6vK5
 j1GZj8Ry
 KgboGa1AyE9wa92qXvFVGvu8Ki68FOTL2MV+ZRussuVQkwW4lg9ePSDe9w5w9aNv52OR+Dm83a61xAiN0xmH2xXd2/SIW4Q7qrvkb5z4uaPJBcd7ouGQCgT3N2pa806Dqi5uxFwMEce26cRJu6L+w2HJIpAlkMFZj18SJ+9rvv0E+FtfyEJ0OWZ/VHzyR/MoI8tCbiBQSdF4BjSGHiC4K7xkzSZiHCh6AtVV5juLeWIml6SPX21zASZ/NrZISgmRhKuoHSQeTQT9tLnv6rCSKWC/1WqugsKvFNE6qjyWvyeUG2AT5Ss4VzYX2cyPG3uLJPjYYmAEgnr0Ic3CEDDfGKEHdysX0kgs+Mb8j/4smz9PN3OoxhV5uhPEsqxyQ/8PLJ3rjAVDhzffJwaU/vnuRJmMWgLjgnOCuJZMcPX7O/vg4I2oDWboz1hP+PTbjufOTDNzAI7cpxeUpvxTo/GjFAsxYAsGiOU1DwxJSkn01L7eXoeNi/DdwUEG9cQVIqZD7A26WWe1NBU8fs+u8fTX7XIr/ri78i8jhT/9iDwtsRiTZSsA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Alvin Sun <alvin.sun@linux.dev>

Expose the task's address space size. It is used by the Tyr driver
for splitting a VM's GPU address space into user and kernel regions.

Signed-off-by: Alvin Sun <alvin.sun@linux.dev>
Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>
---
 rust/kernel/mm.rs | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/rust/kernel/mm.rs b/rust/kernel/mm.rs
index 4764d7b68f2a7..d2dfbb7d43972 100644
--- a/rust/kernel/mm.rs
+++ b/rust/kernel/mm.rs
@@ -149,6 +149,13 @@ pub fn mmget_not_zero(&self) -> Option<ARef<MmWithUser>> {
             None
         }
     }
+
+    /// The size of the process virtual address space.
+    #[inline]
+    pub fn task_size(&self) -> usize {
+        // SAFETY: `self.as_raw()` is a valid pointer to an `mm_struct` per the type invariants.
+        unsafe { (*self.as_raw()).__bindgen_anon_1.task_size }
+    }
 }
 
 // These methods require `mm_users` to be non-zero.

-- 
2.43.0



