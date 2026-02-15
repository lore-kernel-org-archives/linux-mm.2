Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14F58E63F2E
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 04:11:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A0A66B00AE; Sun, 15 Feb 2026 18:43:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74F5F6B00B0; Sun, 15 Feb 2026 18:43:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 672956B00B1; Sun, 15 Feb 2026 18:43:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5E8B46B00AE
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 18:43:05 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6E0371B4E0E
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:43:04 +0000 (UTC)
X-FDA: 84448319088.13.69079FE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id BA838180005
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:43:02 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tpakzWk4;
	spf=pass (imf06.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771198982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sJj2L037iQtufxieUY8PbvgHzWgRsQA2X/h+3AZOBmo=;
	b=Mr48M/Az3rKvxmomwrW8LBr3uh/BaAuONJNElW/pFfdJxZ+v39Zfq6PLrOO2+2fcDNPW42
	GqwEpqTjpv/I2Ha08yhQteL/JN9azROqtqKHo8Dhb10UQw717nmcfgzdRL22NhBiZTSKgr
	ms66/H+pdfex88h37qPYIXXM91MTjkM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tpakzWk4;
	spf=pass (imf06.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771198982; a=rsa-sha256;
	cv=none;
	b=Xs3UXud7lGJuXeaNDP/7L2ygLp3PAfQrxwmvwCerlowWEhgpGvAi7O3RnCmrEW/qir9BuH
	jDGzBg3tp6uUhM+hAY7VgrZ2rmYopLqosHBE0vf1bzrhoBdLq3y6BQf+3pEsBPMfFlEf9H
	NlVbH+IqTT+a+X3diRLQghx7et1dRPY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 54AA76013E;
	Sun, 15 Feb 2026 23:43:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74930C4CEF7;
	Sun, 15 Feb 2026 23:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771198982;
	bh=fZvIGl58JonxCsHjE1MOz0gJuaXvox3LIYllPG0cQyo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=tpakzWk4TWmcbuhpkBUEC9edsz+5JRgd1QpogL+InpyA0YDVT/qXAZTJK+BcS6IDm
	 4eLxyaf8IQfkbJw7hCl0onMo+VNhknT6ZzMihDkhrt6S9VkdC2fwHD7T26sVa/Pv1b
	 HXwx08mbXDAKhZGPMHdRmOohz8nZB7elUkYYF+Jc2uvEaVxcemosU6VoPBJr3XW/0K
	 dslY/CbFU9/WJYgyDZiCGY5ckt3eIqVvkEQPB28TPuwZGNhXcPEdTOdeA/vWvNPDji
	 4E59Cf0cRQ61S86hTjXM0monf/n3ZjwZVbeoqMoMjkBaV+RNbNZGHVy4G40q55Nhog
	 76Fh5AJmXKyIQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 16 Feb 2026 00:35:08 +0100
Subject: [PATCH 21/79] block: rust: add `NoDefaultScheduler` flag for
 `TagSet`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-rnull-v6-19-rc5-send-v1-21-de9a7af4b469@kernel.org>
References: <20260216-rnull-v6-19-rc5-send-v1-0-de9a7af4b469@kernel.org>
In-Reply-To: <20260216-rnull-v6-19-rc5-send-v1-0-de9a7af4b469@kernel.org>
To: Boqun Feng <boqun.feng@gmail.com>, Jens Axboe <axboe@kernel.dk>, 
 Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
 FUJITA Tomonori <fujita.tomonori@gmail.com>, 
 Frederic Weisbecker <frederic@kernel.org>, Lyude Paul <lyude@redhat.com>, 
 Thomas Gleixner <tglx@kernel.org>, 
 Anna-Maria Behnsen <anna-maria@linutronix.de>, 
 John Stultz <jstultz@google.com>, Stephen Boyd <sboyd@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: linux-block@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1048; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=fZvIGl58JonxCsHjE1MOz0gJuaXvox3LIYllPG0cQyo=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpklguOLYxvU7ZbLaMRp9Hmd+T5HDAKD73QjHU9
 fYsKhE3Q8OJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZJYLgAKCRDhuBo+eShj
 d/JHD/0Qi2wOgU0MkzrqlvaS/lF0f0454+YaKacIDMS3nRLwpUa3xzj4xTQe2g3XcReJipitalT
 QVhPor15WdaNkr6AQcEeJs9Mml1rIsQFXWVK/KHwShX/ikW/jZiVME/UC2F1dWrL/P2IscSS8+r
 6jfRd+XsFzduzj11vUU7XlPQDV7TXq+ZJ1if4wVpTLwvR9LyJHp+mHtx/4seUn3pj7/9BI0Obng
 C6PMUYI6JJNsbjcmjO2t7NbZwnlrXkyJxURPsW5B8uTNt/k56NhTKQS5cpjcMkkMozVX6zp8tt1
 xe3GhZW5IsdQAe5XIJ0NiaPs4cL5in6gEx0jefPwu4F9lw+do6qvu1qKqZ+sPofYcLSG+y/9VyW
 QuIYVyAkdmvKwdZj2bId5oa/Ae4QWnioW/oKZ+v0POvs6raOLo9c+F/DMOmYNtb59WaGcU8gFaV
 jZTvQmYfMaS9ZrdUXE0rINFy7S8FcwPa1kmsCTFLzC/C4KCdJ7N32/HKOWACKfY0HIDECz4IRbR
 oxlMt4WWgbLKN6chtkBvXUbxhBR/tBabfHH5NV0US/xMsYc+ODU9JHYiasnbiO3sdP5E6dpLesk
 batWietAxuT0bgcv6zPNYoKn1f4TKNp2BFJKohYo/pW+aLS6Cb8uUVL88jiaW/HQBf7EY6PokTs
 llKN6jpceUvDq8Q==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam11
X-Stat-Signature: q8dfnd6gej9z1gy47znmz54i4ugqd9ct
X-Rspam-User: 
X-Rspamd-Queue-Id: BA838180005
X-HE-Tag: 1771198982-549198
X-HE-Meta: U2FsdGVkX19LkBqQhhQ+18i6/2Rm2heeaTuWEqDpQq3HvqODT1Da1ZNMjQobSupCWfEvgU+MmZD/lAjIEv082htOOG/GEDN1EIzW8WKHUGD/JvSTTFAeEclFvPkxqj0qNCqEq+hN/qVxJn14S5R1CK9CWX5/pMd7ESVOj9X/FHmLLXiHukda5/+dGPUvRXeNVf+zDt8aBIbZBXELy2sMvo32/gEwM2zPgX3jG2ylOKU5M4rIPCmarJTWdpYFWvviSfMRaH3nlt2f87ddu4+P3Lt5y3recn34UjfKaNcUISoGlCP2iQasVXlpOT+UCv2CvvylB0GbW0j/N9aAMKQt7MMeNrW/8jIVH7SpCpSblNknWCvjztMF64ga0a8+79oNsns/Ob0fijjFNJvP5n1uyS8AmXML91ea/OqVgzze1M2bTTgLU+jlVaUvDLO1Ngm/E9G/d3paW3VpYmq3ZkJm7LTB1EckWs/RmIZ5aGcTb36Wv30c4R0iJbXbvtZ6fn3zMYFLdoItdd/gQlWF/2D1lXnLpduhzxASvSP3NDcAPamNHDopb+qsrWorcuRJHQ0PuWuwBs3+CF35ufUebqRMHMTUocvO9gDntgxzAxbLZu6Wme3TAKVx+o0FDDLNcyNPD9v9eWrOpSItMH9ye1w9ZfNOkoJsFl8+eoV0qs43oOKLGTv/8pfOlEJt5ZeoS6IAK5Zul8I6p/R23Mw/FKBezFoz6F26lW51vXD5Os6Ys3tgyJ+D7F1rfF+sWwG3vxtuyV2qUcfmLLCxFcokBL+R+GVGG4rGvzu4fBxvFyaszzkqCj7oM8wFM/KubXzp+euYHrJaAXCjRGkr12xIfn2FMjyIgJTjpWBF1+LgUfhZo4TMiONXjM6trEsegncIKu08h+bQPOvYu6dThS75iMxdNw7t5R8mnsy45kbiskyCK2g4SdOz24t/NuVvV1e/FV3lwhNryNde+YeD5bAsU02
 BsEyiAsS
 vhDgjYDBTbzGOMVBPljut5SqyjsiLmjteu8z2P+iPwyeUSIt4VSfxfODYH0JJRamv6DJ/VTK6DwA9UySjJnjS2jw8EL9CJQgPfUr7B5JHP4IinOF5CPWEutvS8gqGfo5nt1dSKBZlufkTqK2nI3lYWSWgvfzBhbp9RWO33IcPaBcwe4Gf8an19NQ9nQtVblM/jl/KNOI0/G2/V87k5sCxQVvuMu0w783WTnDCy9CQS0iQwU6GLiijZ/0TCLTG+9NEqweQxfD8uOzMzxoz35J7T8Vn+j0t3caBIJn30AQlaAquVBbzDyFFfxYZTSPn15bufq/b
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a flag that maps to the BLK_MQ_F_NO_SCHED_BY_DEFAULT. This flag selects
the 'none' scheduler during queue registration in case of a single hwq or
shared hwqs instead of 'mq-deadline'.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/block/mq/tag_set/flags.rs | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/rust/kernel/block/mq/tag_set/flags.rs b/rust/kernel/block/mq/tag_set/flags.rs
index 768db938b9a95..1fca4fcb4dd20 100644
--- a/rust/kernel/block/mq/tag_set/flags.rs
+++ b/rust/kernel/block/mq/tag_set/flags.rs
@@ -15,5 +15,9 @@ pub enum Flag {
         /// processing IO. When this flag is not set, IO is processed in atomic
         /// context. When this flag is set, IO is processed in process context.
         Blocking = bindings::BLK_MQ_F_BLOCKING,
+
+        /// Select 'none' during queue registration in case of a single hwq or shared
+        /// hwqs instead of 'mq-deadline'.
+        NoDefaultScheduler = bindings::BLK_MQ_F_NO_SCHED_BY_DEFAULT,
     }
 }

-- 
2.51.2



