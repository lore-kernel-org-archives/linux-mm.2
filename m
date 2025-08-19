Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0637CA0EED
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 10:34:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A3EC8E002C; Tue, 19 Aug 2025 06:34:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 655478E0001; Tue, 19 Aug 2025 06:34:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 459368E002C; Tue, 19 Aug 2025 06:34:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2A5018E0001
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 06:34:56 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C832B138EFC
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 10:34:55 +0000 (UTC)
X-FDA: 83793148950.09.D51F70A
Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	by imf29.hostedemail.com (Postfix) with ESMTP id DDA24120010
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 10:34:53 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="rDLJz7o/";
	spf=pass (imf29.hostedemail.com: domain of 3TFOkaAkKCM8v63xzCJ2619916z.x97638FI-775Gvx5.9C1@flex--aliceryhl.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3TFOkaAkKCM8v63xzCJ2619916z.x97638FI-775Gvx5.9C1@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755599694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=08JqJr7G1gjWdMKCvvnL7bTDodkNWFyfbH7nQBOCVjE=;
	b=B1jO1siraGXFzVk3icXNCGFqTNg7P79zpWz/8t2pOacJ85vI+HvwGhns/mliHoXYOQisOx
	eiP8iDwznyytB8HW7EHCCm+x6riWGpaaaNgLjaN6HhxcIBYXwmE4zzK3E5pMoMhZenGmfi
	TTXbTTW1pimp2mfLaljlQ8b99iolqNs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="rDLJz7o/";
	spf=pass (imf29.hostedemail.com: domain of 3TFOkaAkKCM8v63xzCJ2619916z.x97638FI-775Gvx5.9C1@flex--aliceryhl.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3TFOkaAkKCM8v63xzCJ2619916z.x97638FI-775Gvx5.9C1@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755599694; a=rsa-sha256;
	cv=none;
	b=8SO0bfWRRVBGKyhW04VtPjsVY3IiZrKNvKBjfzG7+0l+4Rt/x45O3tAPPs7DV71XRUwrC9
	gCvd3N618WeOladQYoAJZtFEmdhS8qrajOQOllRNU08v5FlHcK4ubATrRet7lE6XH9NjWD
	Ejg1eDrM9DLjqtAY3o1jFbRZZW+AnK8=
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-afcb7aa89a3so400462466b.3
        for <linux-mm@kvack.org>; Tue, 19 Aug 2025 03:34:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755599692; x=1756204492; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=08JqJr7G1gjWdMKCvvnL7bTDodkNWFyfbH7nQBOCVjE=;
        b=rDLJz7o/+tqcaphAhWFBEA/v4YH6YoTfRENWgRXPYcqyElLTw6HkKTz4HVwulAt+4J
         RYD//0Bu/p9+fNmqOXr4yuUGw0DxOfZO/OPB0XYufQd9aCCVd3VGXUw59PUAQNFVYF5j
         TnvPLasPfMaE+9SeH/MaE+QlZ8rmfKsQyVoP4Jl1v7xaPePDiL71uQpIjySm4JMJ38AE
         Ylj9HqerT7x7HGn+WRA7P9+n39HRI7OB2614AfkbWZt9Mc8s80PWdvOZKC3keJ/k3PsG
         SQNTnlRgpzRxiUbXANxhd7yH4HaGpnRERMeOaTQqZt+1+n/VL/Y8erIJsYiW56Ql3keV
         c46A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755599692; x=1756204492;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=08JqJr7G1gjWdMKCvvnL7bTDodkNWFyfbH7nQBOCVjE=;
        b=Z/pKOqWRjmOZjvk9/Duv34JtRwafP54eej5W/Y/ZBxoXhr9KmfZ/djHcc0nhALvwj7
         HTWTk+N0GMLNgSVD0Vq/2bYqWNO3fRRGpF/8NhcOGxYvX8nM6BowlNKbwG3sUuyYnAe+
         JAb8u2bxSwm/RSmWF4tnVJErvMggDaX5CRWOd/A14SOhHRWia8CeIRerf+BwaAQDqMs0
         V6BtWLyjkaEMYxNdvAybiB68SjaLQZn5uyKf3wSAlU3gXIKA7nlGODQ3U8HzyxuyNlrR
         vqnbVnL31Z4Q3UYLKvrzDubZBNG6GhXfljRJKEWlXLQmbt0o+tIF5bQSsLFxCbTDElQQ
         MEUg==
X-Forwarded-Encrypted: i=1; AJvYcCVLbIGUraf+RdWA+OlqpvrlrMBAQPeaRhVaNuBjN1oLW7cUeMleonI18gNbo6tiAlJ85Y65Fbg9xA==@kvack.org
X-Gm-Message-State: AOJu0YxeSdm1wJVMEL9mE77TJ1w2WUocdTK1AYOR28E1e173hd6JYsUQ
	/hyWpK2oUGQs3ujl4g51oimV9CNHkxGkUeO4Nv1dJIsC6yC7/txbuc+D3+0bdswH8CX0edkFo3Z
	j8hVNjfzwX9rpMHQsAQ==
X-Google-Smtp-Source: AGHT+IFSburLeN/bZPFzEEv5PgVznU3wJsVBP4Za2PFk07p+aJbgcziyUbh1qo8zQ4cn+Sc8HH0/fLdWChO+yMs=
X-Received: from edf23.prod.google.com ([2002:a05:6402:21d7:b0:619:ac6:aec3])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:478b:b0:ae3:f299:ba47 with SMTP id a640c23a62f3a-afddcfbe96amr204399666b.32.1755599692268;
 Tue, 19 Aug 2025 03:34:52 -0700 (PDT)
Date: Tue, 19 Aug 2025 10:34:42 +0000
In-Reply-To: <20250819-maple-tree-v2-0-229b48657bab@google.com>
Mime-Version: 1.0
References: <20250819-maple-tree-v2-0-229b48657bab@google.com>
X-Developer-Key: i=aliceryhl@google.com; a=openpgp; fpr=49F6C1FAA74960F43A5B86A1EE7A392FDE96209F
X-Developer-Signature: v=1; a=openpgp-sha256; l=1889; i=aliceryhl@google.com;
 h=from:subject:message-id; bh=7lgTDryzjPL5Xg/gMsVbQOEVBBvts7hg247LEVfqcuA=;
 b=owEBbQKS/ZANAwAKAQRYvu5YxjlGAcsmYgBopFNJHnIw9YCL5xST5YbjRd/Fzqnm1QmO+dTfa
 R9nNQweAv6JAjMEAAEKAB0WIQSDkqKUTWQHCvFIvbIEWL7uWMY5RgUCaKRTSQAKCRAEWL7uWMY5
 Rps+D/99qMIDJ4FAIG06+w4Pu047hC0WFaEATdHVtqYrnG0o9tOBFTfCf2vmCTWFGrKSDW7Dtrp
 eryDx27c4f0TvBZK96kS4KmjNAWOnw3rPIbkY6By4WnBvNg5fWrKNNyI3QDZ+igp+xOANglhCwW
 KNoXBOmawcL+/Mh1TNZjNYjHr2ORd73s4qCl2KwA6fMRT0d/x2hRo5nk+pR7PQycyLa3tFVPGPs
 wJyhT0wBS9/y5+Gy+DMf2e6PBSq/+83z4WwL56wOLBv6AjEvezT3B7N6lY9GcVwIXVGZjxRsimb
 CA7uYTZ8Zsh60pNTfARC2FGcVpKsioQPaS2qfXVRfbjQgXy4TuxOxU/wdl8XEtlCl3hgOP2MVVy
 P2wgzi76vgMmK4xp7OdzS41dyaFHOIfRnRfFSJgFt0VtxWffccMpRfHyRhSfJXai7eKddUqZhL0
 6Tgb3ip7bQDBqVLn2KrXGrWXDVmKGUjP0Tyvhip8Q7O5NMwCqNQ26gZdlhF2/gw0ZQlWipcN7b8
 oLvmfvoYyk9iN7KbRPb0cTzn4QxYcNPy7kGAo03XDAHqioDNg6N3hDi/fDTtEw909c1Rq+SfMOI
 f7GZxUIiRK/bVeCKDjgqR6ds9j18xtrinjh1lJbIQtpNmDELQ/BqdlnlGGHeH/sM+Ks2B1eV1jD 0RLYklyP7QzszoA==
X-Mailer: b4 0.14.2
Message-ID: <20250819-maple-tree-v2-1-229b48657bab@google.com>
Subject: [PATCH v2 1/5] maple_tree: remove lockdep_map_p typedef
From: Alice Ryhl <aliceryhl@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Andrew Ballance <andrewjballance@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?q?Bj=C3=B6rn_Roy_Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, linux-kernel@vger.kernel.org, 
	maple-tree@lists.infradead.org, rust-for-linux@vger.kernel.org, 
	linux-mm@kvack.org, Alice Ryhl <aliceryhl@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DDA24120010
X-Stat-Signature: zc4cs4zwy4yhduobqcd9budurdgmb88k
X-Rspam-User: 
X-HE-Tag: 1755599693-456507
X-HE-Meta: U2FsdGVkX1+En6GM07DkSxR2viwkS73DUlvB2YNsSUgolxjQX1bbNxuEpCDq9bKD3rtDCn0qrsvkJuVKAOAg2GKiwRuq85MF0sI9zqsN/MUNVm+k1SmjntetAe/dWLjKPfM8Z/5qIxqL0qAFqC+Pqk146apC3KFLYh/8iXQffS1Vl5nDHrPDmOj91MH1vhKfJ1G8Kt6M0L3ogTnH9WmC+rcgmJZ1xQF26TnPhX5SkrmgihUTyMQ7l9fp7j1+aQq9GLanNJXfuA1PwGJ/aC4LrrbMtXWgkaw+1kkQ1qSp7nIa7l6JjFvtp7jWdAnqiMx0n49kX/496MEMCh4RyIGFFhtsSAR0tLoPl9ARQekFe3cZdzCfUIxkB3faIdv+A2csceOLKmJdBe5rP1sWaaSoQ07fbJ3270LBgucnDgouIOGLILlfF7n4tkoWGqNI/ATo2jxxkfG/3dqwIq5AzUv2b61De4e5yqslB7J1JeBhSNWICGJsWawgSe659oAsKR5DU3CYo8o4NoXxBXF9YtOmg3VnXGQlVU19ZKIedfX3y5FZC6wJzuSGzC1tx8JAxL+GAvaj6bWJzt/3ELD7EfPACdPVk+XSsehfurOijiEE2P7zl3rWZUKlJoXXE3OW0dncOhWHqj2meRG4zY1c+G7UmPVdXiRg4apeDTUU7UD3bM9w25S5fTtBfQJRzZbtxbIGyGh7hn+e9ZGkN0LavUV8mCDTENwjFjVcE/mNMAN7RdQWSAsDYLhBqlDYm90HusrBbi/UflwOhQmk6THTmlk9yvDDaaxNpJeIpidrqHDIj7Q6ZzxfUbeGdTGAm78TY/QR3Y4ukT22zXIdDAgyi+Vf4bp8TrMsVBILDPNMraBYpPQTj4nnNuAyB6iK7nYXIevzOoLaCqvZ8SQD5GKA6j/oeaZyTeiJ0KhGp03XP5pB+EJDrvMMFfbvJFHMaPRihx24UYFfbafKxqusMk8+rLO
 EzyUc97y
 5IZUuzzf+KsxYDSQAgdriXv1sCtOU5wSLXC6qYbrsYDzw16GDBhRPTE6g7EfdmHsK+tOHnIyOb7NATIAC5TdYzF42+ZbL0YY/iL8moiMd1d75rBRKtyxiDeSmCO5zlqn3+rDMnB84cgRWphIQvYaTOHUWR3qutRMPRQUyS+Hq/5DSdUwksCBRMB8SSNbhpMZ/we9qbBj3tnKTsEKSvS7fuFFuc66KP9yQU4q6qis8tVV8pl7Yr1fr1ZOcWggfk9onCii2SBMCBA+Us9mnLwjxRARyPpwUWNT3Adil46A/WlAIXx3pNtdP3IXKLwi69VDXDZ4rfuyp6EBN7t49QCRmdFlpKhKG9B3F5AFzqf7yensVLmgfOwsj8skYnUT56oF8fvnYToy0x2MrpsKFnpw9wE/ANI2OvnTLt8psa66WDock3H9REnL4MMZgyoblqwUy0LTFLOfyhh15CQJbQqFqUs2or6EqNgQrPg+3s+/7WCitSR8v17gWFVOd9MfmaBv9o4cGdN0+jPBkVDFMEvu9JYIqRB68rBXteWyvREMm9bgX6r6uvyh7MfPtDqDMIBrKoR8GzaLxKe+P3eQn3Z/1I8KMgqtr+6OojUx6pD5EHxz9SI0xw4f8AbS88gZaA9B+6OcRDk4CtAuhpmqJZIpS52Vp8hjpuo4e41o+z23XPFzlZfUVAJjHTc4gjdAQVLrr1ioP6O3KMQekIRlBMZxEWznYdg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Having the ma_external_lock field exist when CONFIG_LOCKDEP=n isn't used
anywhere, so just get rid of it. This also avoids generating a typedef
called lockdep_map_p that could overlap with typedefs in other header
files.

With this change, bindgen will generate better definitions for this
union, which makes it nicer to use from Rust. This avoids a cast in the
Rust abstractions for the maple tree, ensuring that Rust's type checker
will notice at build-time if ma_lock is changed from spinlock_t to
something else.

Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
 include/linux/maple_tree.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/maple_tree.h b/include/linux/maple_tree.h
index bafe143b1f783202e27b32567fffee4149e8e266..8244679ba1758235e049acbaedee62aae5c0e226 100644
--- a/include/linux/maple_tree.h
+++ b/include/linux/maple_tree.h
@@ -194,7 +194,6 @@ enum store_type {
 #define MAPLE_RESERVED_RANGE	4096
 
 #ifdef CONFIG_LOCKDEP
-typedef struct lockdep_map *lockdep_map_p;
 #define mt_lock_is_held(mt)                                             \
 	(!(mt)->ma_external_lock || lock_is_held((mt)->ma_external_lock))
 
@@ -207,7 +206,6 @@ typedef struct lockdep_map *lockdep_map_p;
 
 #define mt_on_stack(mt)			(mt).ma_external_lock = NULL
 #else
-typedef struct { /* nothing */ } lockdep_map_p;
 #define mt_lock_is_held(mt)		1
 #define mt_write_lock_is_held(mt)	1
 #define mt_set_external_lock(mt, lock)	do { } while (0)
@@ -230,8 +228,10 @@ typedef struct { /* nothing */ } lockdep_map_p;
  */
 struct maple_tree {
 	union {
-		spinlock_t	ma_lock;
-		lockdep_map_p	ma_external_lock;
+		spinlock_t		ma_lock;
+#ifdef CONFIG_LOCKDEP
+		struct lockdep_map	*ma_external_lock;
+#endif
 	};
 	unsigned int	ma_flags;
 	void __rcu      *ma_root;

-- 
2.51.0.rc1.167.g924127e9c0-goog


