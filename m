Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E03BEC1E92
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 10:51:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCB236B0093; Thu,  5 Feb 2026 05:51:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA2F46B0096; Thu,  5 Feb 2026 05:51:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA24C6B0098; Thu,  5 Feb 2026 05:51:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 950846B0093
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 05:51:47 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 25DBAB99F1
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 10:51:47 +0000 (UTC)
X-FDA: 84410087454.11.D8DA412
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4537D100016
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 10:51:45 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ED3fO4cy;
	spf=pass (imf14.hostedemail.com: domain of 3P3aEaQkKCJAu52wyBI1508805y.w86527EH-664Fuw4.8B0@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3P3aEaQkKCJAu52wyBI1508805y.w86527EH-664Fuw4.8B0@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770288705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RMyX8uRGOmUN6KZEX+IAO29sQdtn60nQJQNJ760wFa4=;
	b=dzc6/mLlxSauPcHyElbr0RhF1fx07EmXuGwNt+0lAGsG+llgaJ7begw+8EB3XNN77vqxWC
	TympeVXdZkzxCnQJIdLgRlhgPxqIXdJ+B+cDTVIVf7n7lPnNbsTWsr9da3oqG2iVvIYupW
	wgEJLh3HUjlnN2uTbTHx5hn6VEZEozY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ED3fO4cy;
	spf=pass (imf14.hostedemail.com: domain of 3P3aEaQkKCJAu52wyBI1508805y.w86527EH-664Fuw4.8B0@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3P3aEaQkKCJAu52wyBI1508805y.w86527EH-664Fuw4.8B0@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770288705; a=rsa-sha256;
	cv=none;
	b=USOCv+cTvgDGSOH6kzPCLFYzZuZeoFFhwvSDAwbN6tYcSjQIcyWyuTT0PEc63S5wyAgdvW
	4lzMKfwmuFxyg+5dpEquvKx2DgLLLBZPzFvqGucaHgnXzlD2ZR6/g4yQ9BuDdo3y2FC5vX
	JJNWykkzZBsiMFk393dknFdvIM5REyc=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4806cfffca6so11237225e9.2
        for <linux-mm@kvack.org>; Thu, 05 Feb 2026 02:51:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770288704; x=1770893504; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RMyX8uRGOmUN6KZEX+IAO29sQdtn60nQJQNJ760wFa4=;
        b=ED3fO4cy/I4rZQHpgi63poFBaASQowqypmC9/yP5cO0mysUrYSTvl55wMiaj6dX7Ha
         IElDxaeyl9JqYT7UzTWXyy7vhh5QXwNdMbpvQwzF2y+DObIkWZEDqrPfj/e1BzVokks2
         qWO0EypT2xruE1hX8BjfUK04MpikwzTPijTiKxkZekO8iKodJ0u9IrJ/p3upTgFAhhb2
         R0P1NEv48KAHpBOMcnyKRMS5sNmdHbOJtng94rWUN2krVM8LcVL6aelJbcRHykWvC93T
         LkWdp9V9WzDkjsH75TTCkVE/0z4LebXhHy8RTaruXs7PWOBQocK8JxLeuYNx+v8PfFy3
         U1qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770288704; x=1770893504;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RMyX8uRGOmUN6KZEX+IAO29sQdtn60nQJQNJ760wFa4=;
        b=VHVBIqJwJrKIvZaSX/Fq0Tm7YhBuExm8rmTf8yH2ZAxBz7hUHw4hk3a64rhdf1DpNh
         +0ykVwVcFsjPFRNxf7NFV2F4s1RTg9Xxx91GuWEYuj0yvMmR2SVscaoSwy6N1cIj8Q91
         F1Nm0OslBSEi+IUuVx5CvzmeEg8xUaTJNLuaonCiUhpB82cCRc4ang6B+HBI7WL50pof
         DUiJnPWgHniJZsXdwTScJddgVlc7IHwHu5iYX7Geys2nG1i0PHCMDaDbig/FUg8uNv1R
         g32XtABTcdAchHG/pjYGPw6TZeluXzhHc0TBdwU89qWKd/ze3bm/5BwiQYjrMc+zwsim
         /FMA==
X-Forwarded-Encrypted: i=1; AJvYcCVPEuH61ktESCBHjNYbzU2TzInGN4RrvjzpDtOpcVAK/I1VxNxp3mjj07Is4JnKrpeFrbFynXqO+Q==@kvack.org
X-Gm-Message-State: AOJu0YzjtNIWp/x+FU4qFyPBq8y/XvQ3IYiO0sAFfKMpdE7BoHX8xdYN
	EfLdI75RHHxouWCkpJ4QSN3JfHhOY9+tNIeJG4mtMKzDAR7DQUa7y2Ot9/xcV79E6QJDH5Gzqdp
	lvF+BMBGHKETVwWEvQQ==
X-Received: from wrf23.prod.google.com ([2002:a05:6000:43d7:b0:436:f00:c1cf])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:154a:b0:482:ef72:5778 with SMTP id 5b1f17b1804b1-4830e93478amr80493955e9.8.1770288703598;
 Thu, 05 Feb 2026 02:51:43 -0800 (PST)
Date: Thu, 05 Feb 2026 10:51:27 +0000
In-Reply-To: <20260205-binder-tristate-v1-0-dfc947c35d35@google.com>
Mime-Version: 1.0
References: <20260205-binder-tristate-v1-0-dfc947c35d35@google.com>
X-Developer-Key: i=aliceryhl@google.com; a=openpgp; fpr=49F6C1FAA74960F43A5B86A1EE7A392FDE96209F
X-Developer-Signature: v=1; a=openpgp-sha256; l=1564; i=aliceryhl@google.com;
 h=from:subject:message-id; bh=lHbpClqy5L1XyxxmB7KNUoFqATCRTP8Er1SZGKGJ6tI=;
 b=owEBbQKS/ZANAwAKAQRYvu5YxjlGAcsmYgBphHY4aveNr15TrzG7ybOw4TJxbQ92vW+WTNFwe
 SWpiksgXOeJAjMEAAEKAB0WIQSDkqKUTWQHCvFIvbIEWL7uWMY5RgUCaYR2OAAKCRAEWL7uWMY5
 RpEbEAC0yt4w3VlnWagA17RkTMJUz2p4xk2iEYS9GjmxYT8blDHPFMYFaItdVcShUAHSGKR/5uP
 sp56JdoMwss+uH23eVwJiQ+HbryIOXdKVtLt+5oKl0UqRnr5R2uiwWlvusffAP+LAQhX7oP7VWE
 V+SwLxDVamJaGEIJp695c0KtFyx6MVHwB6+VNY3ABU5KqkjaFcDy1b97UDGC14f7sAQcpSxk7YI
 ZQRzS/O2c29hQ4VJw/Q93nYRKuPOnB4Lhm5nFc9IZfQJ6xZhp+ND1h6pfZBgfP+78TTEY+0O0RL
 p6niPOid/1OsqecLYRt5KuPv9CwTXmislZfm6l6AtWKzV9HSL3UwjzYp89wj+8/2y9Alk35MqDB
 Vm3YEb/L5lP3F24xewKmeQ5qtr5D6ypVUuOJ6PNseGVxaD1uHJ25HW0xZ0o7lsd1Natiy7AogWP
 Z1cRoiXXGc89E4N5N343Mb2Bmc8HofAHx+W/n1Kcs6XZf1phN7RKpkdqTysMnSSx6ghhABdaBE4
 9xSTp48eyJq9u6ArYggMUOck58X2jH5+HWSOTpAUC6omijpbWoq2lBtdcV3fh9lvrDtVR533LAh
 ppXfMNZX5Fp+lnVq12G31nZs7qvqYsQT/QCxlBJIsYHttULTQrcsadK44k6RzJrRzBwoRAQWvQ0 UruzpTUpSPSbVnA==
X-Mailer: b4 0.14.2
Message-ID: <20260205-binder-tristate-v1-2-dfc947c35d35@google.com>
Subject: [PATCH 2/5] security: export binder symbols
From: Alice Ryhl <aliceryhl@google.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Carlos Llamas <cmllamas@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Dave Chinner <david@fromorbit.com>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?q?Bj=C3=B6rn_Roy_Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, kernel-team@android.com, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
	Alice Ryhl <aliceryhl@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4537D100016
X-Stat-Signature: j9nhpn6m67w5n9xewrbphdfi18cuknxf
X-Rspam-User: 
X-HE-Tag: 1770288705-807983
X-HE-Meta: U2FsdGVkX1/RKNFQigzsS7jycaOzkEV6gg/kIYqEzx3hI8vMIjLgYj/nFWQF0m/TMJjS4Fkm7WEIvfQ3+xeEMb2Ch5McjDnUxSy3LtbN4fETYEZxjhfW+51/Asu27A3sK1nNc9KiJr62+lQyGA/0WbgkJOEC6Ca1qsaq2hMDhf3VxWpmWi+GHkx3ocvFoCllB3wvfjMAw/OYseVnLVwS0QvzIL5U3j/2daSqJvVnagnFY7zLGDYqDfXbRIJO/3jrNmvtzJXtSx52x51Ka/3OMSBbN04OCoY51a0q8oS6JerqaRc1NFd/rPQAykD+EucN9ZYlE+sJU3q4BbWVLzFoldC5ylf+N50IhbNJr6Hl/68gf0rIcbtxYxkOEnySd4MtTk8LVPMRRKPIs5kjoh7p/9XCCA478+N57xPxqP5zKLWDWjleFrev77ND5/0jmB0yiIZx2vZ5nWJ/Z9slfOVfA1zeMnxQYpRoXOYq9xk0Ce807x5lyaF2tuW3QnzvCn6+XAjIa02lCOGFxhY+YzPQLDsLKKx6tMvno9TJVXM3tLXh717KmbjaRI3Wye6SXQqWjqN5xs/dRFf0QPxYu0jSkVwSR8LtJA+xlwh4vgJWkBSfRi/0yh6+Z0dzbPWsS/kY15nh9sMpNoeO17Qnl01zI0jZhwQfp8XUNzr2+qzq+ESifoUv25lzOenJIYb2CL0N1lhmbckIyZafR7UCGgH5bJ7j3nfJDao8Sxf5JnKIu7s1xh1kx48yLvYDYWuRGaDPPqGhRP9F25YTeTInE4/NkEdnKbFW2JmZahzLDw9BSL+yqNu6fwUcxivjXDa+5uVieHDdQeruoTEEt+dIkyVd9KbMdowYNjAnt+8w/z2tP2OoO4GaNMNXd3AslLv9ODBLbSCubFg0pOejQl/9aDT3YxHNdlj6Y6K6eXZvDHkevbh+iyr1BaTtsPueToWyKelsp+7e10sBgaOkHRGMeqx
 035NHAq6
 hF2BKgbGP+DfqvfFGxM6cUnY6mc6U+GsnvWAW0O3zadgDabLl9myLDH4qY6Laad3hGpNFAMdb5le8KDj1bJ0xN92JYy1vuHdtXXo3fjkczxByFncyEiHah8wJ1AHS/FcgzSm9NgKLPDRgmP62RwMC2ujK/Pe5fnGSsdQnaqzDEI31Lu+YO/L7qBz/J0O8C4uVPLHIpNxzMlS8KA52Vn48RStFHASFdK+RuhBViYLYZM2DOCrun7nJi9KCks1vqkROjM9lkkV1qPY8izqTaBmqLP/skvcV3VmLGbFyAabvVzIaW6BW6VJr8XpWmUgs5NOuZKRfoMgy81PKkUSBxBXJMvNf4iIRO7mfOzZKrLuZJyysAZpzGPUqhYaaAKP0J9aXFV5c1T8dQsXVx8UgfInQjvZ1R/Z0qEzGYDexJQN3ar8MdDINBLzf3XmXAru4vdK4tHrhjxvQzkbPSvu8cfo/uqJikRw1c5f88V/BwGoYBNqndf3I6L5GYNuwWkoG9tb5wQtcawsqIaZcHBM9KGEAuwcA9VKgbRirMc7OgFQ8HmHrEAk7OMq3dJXffM2iYNpyMmxWK0NMxl8YWRomvPh2zNMqhnuU+FNoQZZ2IFu/dF3CBMMah9XF2iIY03i8bdRGnoGWKMoMtGj/4hc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To enable building Binder as a module, export these symbols.

Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
 security/security.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/security/security.c b/security/security.c
index 31a688650601b62df1e536bbe4407817edbd6707..b4776f0e25b33df95379a08a7659c0e5f767237b 100644
--- a/security/security.c
+++ b/security/security.c
@@ -488,6 +488,7 @@ int security_binder_set_context_mgr(const struct cred *mgr)
 {
 	return call_int_hook(binder_set_context_mgr, mgr);
 }
+EXPORT_SYMBOL_GPL(security_binder_set_context_mgr);
 
 /**
  * security_binder_transaction() - Check if a binder transaction is allowed
@@ -503,6 +504,7 @@ int security_binder_transaction(const struct cred *from,
 {
 	return call_int_hook(binder_transaction, from, to);
 }
+EXPORT_SYMBOL_GPL(security_binder_transaction);
 
 /**
  * security_binder_transfer_binder() - Check if a binder transfer is allowed
@@ -518,6 +520,7 @@ int security_binder_transfer_binder(const struct cred *from,
 {
 	return call_int_hook(binder_transfer_binder, from, to);
 }
+EXPORT_SYMBOL_GPL(security_binder_transfer_binder);
 
 /**
  * security_binder_transfer_file() - Check if a binder file xfer is allowed
@@ -534,6 +537,7 @@ int security_binder_transfer_file(const struct cred *from,
 {
 	return call_int_hook(binder_transfer_file, from, to, file);
 }
+EXPORT_SYMBOL_GPL(security_binder_transfer_file);
 
 /**
  * security_ptrace_access_check() - Check if tracing is allowed

-- 
2.53.0.rc2.204.g2597b5adb4-goog


