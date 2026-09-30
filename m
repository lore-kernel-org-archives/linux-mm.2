Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E962DCA5FAC
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 12:37:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DB536B0093; Wed, 30 Sep 2026 08:37:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98C506B0095; Wed, 30 Sep 2026 08:37:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A1D16B0096; Wed, 30 Sep 2026 08:37:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 66E636B0093
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 08:37:50 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D69FD14079F
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 12:37:49 +0000 (UTC)
X-FDA: 85270380258.24.93612D9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 66B6B20002
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 12:37:48 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FoyUwOig;
	spf=pass (imf31.hostedemail.com: domain of ojeda@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ojeda@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790771868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=DepFgs+v/Bioeks1soXkH0LShlVH9SuMmPSryf+3zaY=;
	b=3eGrsCKfo4gaCbhj28PSxm3In9jT3Er4g/N1hirEQ4PShEKj9wpAUUNzPeAkcJGo7Y//TE
	c7oKPPj9wJqouojb5qslknJ7X+a7IZL9hL6unPNz2fY5wmdeYyLUmjI/M16pYkxBtTU5LM
	8sReA/Wt9pCIAMxz+3vK3qCDDTOcNEc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FoyUwOig;
	spf=pass (imf31.hostedemail.com: domain of ojeda@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ojeda@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790771868;
	b=688mQ/BfdzZfUB0eU39kaxKiMj7cqZPtGyahFJHY7/A2CfuKX6EU+gYLuchy7VoNKv7k5m
	qZfkAGGU/KogepQt8BhA3rkuocC7Iu/lc0NBwkAnmFrsFxa34vRi0w8zKjQj1Ajcy46WFF
	qBLkBbC0guRQDPTe9ejfuTYjcmlRhqQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DA1AB60008;
	Wed, 30 Sep 2026 12:37:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8255D1F000FF;
	Wed, 30 Sep 2026 12:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790771867;
	bh=DepFgs+v/Bioeks1soXkH0LShlVH9SuMmPSryf+3zaY=;
	h=From:To:Cc:Subject:Date;
	b=FoyUwOigc+1EnsYpkfJS9PW1cMQqW2kUe/BAa+sys2pVEceApJzZPuu+SH8zva0kR
	 29GONfDMrPaSYjuqCOjG/4F/LShSarpXIWsGHKV7PF6zUPBnNK+WV9jfcj81eMNkrV
	 lTwuNz+NynX3PhLPDjRCc8HVmjaEJHfreFnhNKvSXYTc6rkGIamxLePupDYVI2LRdU
	 befYUtGu62ckZTL+hxh7S8mMEmtb4XhO5lFTpBm5ZW6/PcDrddt1AH8Ax/m46MCYwK
	 nZ7PDrCKQGTlCrMSCB+TfgyawU4LxvbnV+fD8RpBe7J24UB70llSEphEeNgYSxuwll
	 omDnAzFq0qABg==
From: Miguel Ojeda <ojeda@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>,
	Miguel Ojeda <ojeda@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	linux-mm@kvack.org,
	rust-for-linux@vger.kernel.org,
	Boqun Feng <boqun@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Tamir Duberstein <tamird@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>,
	=?UTF-8?q?Onur=20=C3=96zkan?= <work@onurozkan.dev>,
	stable@vger.kernel.org
Subject: [PATCH] rust: bindings: fix VM_MAYSHARE blocklist entry
Date: Wed, 30 Sep 2026 14:36:45 +0200
Message-ID: <20260930123645.302318-1-ojeda@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 66B6B20002
X-Rspam-User: 
X-Stat-Signature: tcixju3uk9kjmn3d5tcr78ohaardmhk3
X-HE-Tag: 1790771868-972146
X-HE-Meta: U2FsdGVkX1+ZSi/eDe3hKeODfZ/JAP8JVONBlmGeLnzEtKB9dqU4FhkJcWmLns8WqdHc3KZYczpTBeieZjNoX4CiQ+6EyJTL4ER59dL+0EMBFvecbXZ5pnfGAgw4t4529QHRFbCvRWhVxpoD1Agd6zv9kBbg7xfMtT+JzJPHWVSx5NW2rWfKqRizjW6F5k9Uooyb/xIb3fxE6UBgHmXPMTpIh3ojcpU7/797LMNibi3zb+RXHWdc8CrabDUmy8D5Q7OyvlLc0gb6Sa+oi9LzhlHgy+OKA0RYtUMEzHExJvP7Tf4sxosdD/6mNwn0j/F7jHOfOiXxblgRoYuQjFeygOTopPEkiL/OU5oFSg4DuqDzDQaqownixDKavqtIkh4Ue3o49CPYK1r0sZNLA3UtHfY10Q8rz0aSeSOnvD/wYh/nlGx0jHs+JLgticZpYclxhpDeQdiszaN8321/iiVdu2v8vy+62VMyxomHGoExtsjHXi1OAwhy8n1Zzthq7OydX1zyNYgbbbKGV8kUdzDgdWGJx88xakS+IZBXBQa0+08d6eUelRyVa0vIC3v7kbRLSvypo7CA3FfOOwR/qyYaM5hbdOG9Go+6dI84UzZ3tttXUEk8hJm0WKBkvBnGU9yVIsiZ015kWBXPPFqmOewf1W5xAp0p4NUojul7f+3R6eHheBxgTVOLq2qUzYKN6aJ8EitoCsmen/mDggM3IvOt1WH458EJeh0vYnZ8NeqiMMmtSieacSE/l3RD0CbbDuQ5kYULMethm6/ber2xrJpYxPBViZKSSdN9HjyFQdZTR0tXLIWgCuuDtBP+Cozn6ehXwsMO7E3mpWQUOUfBe7U4HOyk/nNZq5YS9/HQrFfQsbw9F3PZR9tBJb0Os//Adqvt7GZgUKUAfjgKfRgkGTQWXF9wsMCQ7VwKTi6mctETbgqrRUa9OAVk/h6mRDgHI3t6d5MQFYiP8MgOpXLmX+2
 RezdzeAE
 Bf4WntJkEqiZkUdDQtkZTuS0dd/Nody+AU1PqfJkNggEHA3RQQYDEoLv3HzfTUzoGNnwTBj+QRX/D7hqbo9cSbfoFFMcZvvj4113A6eitsI/LUVy55oYUlKkDXYS0oRuqRIO4Lj5PhRcHxjffOf3SOB3YyeRQoxu54VcOwaqi7gKApRRk1ruudNGiLREhLNaqZH/FXHmGIT+zz4jlLb5eiNZZJA9Y21C5I7wLvrJiW0XLRWhSe2+pUsm4ZsWSBATJ1GyAbcvFB1bx/hdzXJzh2Q3LJMdtOtLTMGXkFN5voPM3+jTdKAAA1UswbDUGX2muzv4S
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 2b6a3f061f11 ("mm: declare VMA flags by bit") added constant helpers
for the VMA flags and blocklist entries to suppress their direct bindings.
However, it listed VM_MAYEXEC twice and omitted VM_MAYSHARE.

Thus fix it.

Fixes: 2b6a3f061f11 ("mm: declare VMA flags by bit")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/bindgen_parameters | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rust/bindgen_parameters b/rust/bindgen_parameters
index 8402b0c93545..93e622aaaf78 100644
--- a/rust/bindgen_parameters
+++ b/rust/bindgen_parameters
@@ -50,7 +50,7 @@
 --blocklist-item VM_MAYREAD
 --blocklist-item VM_MAYWRITE
 --blocklist-item VM_MAYEXEC
---blocklist-item VM_MAYEXEC
+--blocklist-item VM_MAYSHARE
 --blocklist-item VM_PFNMAP
 --blocklist-item VM_IO
 --blocklist-item VM_DONTCOPY

base-commit: 7b5ba47d845f35b04937748a191a1772ffc1f288
-- 
2.55.0


