Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83F27EC1E9B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 10:51:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2076D6B0099; Thu,  5 Feb 2026 05:51:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 154316B009B; Thu,  5 Feb 2026 05:51:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03F1E6B009D; Thu,  5 Feb 2026 05:51:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D8AD66B0099
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 05:51:52 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9402513AF13
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 10:51:52 +0000 (UTC)
X-FDA: 84410087664.30.866DABC
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf18.hostedemail.com (Postfix) with ESMTP id B3D591C000F
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 10:51:50 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LG2WL5wr;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of 3RXaEaQkKCJY0B824HO7B6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--aliceryhl.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3RXaEaQkKCJY0B824HO7B6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--aliceryhl.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770288710; a=rsa-sha256;
	cv=none;
	b=Tl95LSLn8+C2qC7SLDyEcF4kDk2MH4NIgjm26GpQbcZtHsHii74mtlnl+790dDXz/e6QBK
	ZCGGQgRAqfA4iWiW8WCLPrjjgECPe+xIx2tFLu45AxMyVnDRZT99af3nQ0/Q8QB9AUC6iJ
	RNhMrerBuxhgjMYxj/rVpd4BrgYUeag=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LG2WL5wr;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of 3RXaEaQkKCJY0B824HO7B6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--aliceryhl.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3RXaEaQkKCJY0B824HO7B6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--aliceryhl.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770288710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kpaIYad0WHN8wTh3ZSTIrnFcA9kAsyJ24DcP542BHNk=;
	b=g4PwxXLo8D6bIlB+V/yEEm/S4L1RPJzNnGJtggRxGlcAX73aKwKcWzbOc/tXNuYxi42+C9
	BEuNJIdfMz6TSpqBtte2xJydnDDHGxDmwNGKtTOxKqA2DrvFl2OTXdMqRxoJLByRhwi86p
	J+E0GVJZ2iOc66FSJjCkDpU5IjXDDgU=
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-435ab9ed85dso729569f8f.1
        for <linux-mm@kvack.org>; Thu, 05 Feb 2026 02:51:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770288709; x=1770893509; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kpaIYad0WHN8wTh3ZSTIrnFcA9kAsyJ24DcP542BHNk=;
        b=LG2WL5wrJD1mRO/A0Fq8g5k2GgjVo/m+Ol5Wzlz0yuJSKeT286iHGlpjchWzZrvFQ8
         Phs6wu62OoZOlWJdedNO6fUfa/MKUUo2v3QRtR5ojTrPhS+EyE56/k6wGTOAxOzQq39l
         RoMsWPisS2x2Ojfq2mRrZgDj9ZwLiLTN0SB1qvVbO5XdL/i21M1LdfkXPeJLDmFndLLY
         YWCajc4UEetT+8AUj/sHb0ZoRKlu20E5I5rH2823lDRzrUavDnH10WNExB8pe8wmxNL2
         gz69SkavV4BttQA4pA+r6rNbGR15xjzeTODgFop+zys3eLbM6WQaORrZsPP/v8ipo0hn
         BHoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770288709; x=1770893509;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kpaIYad0WHN8wTh3ZSTIrnFcA9kAsyJ24DcP542BHNk=;
        b=pdyppZL1bW5jylVdjDgERopm/45LKTW+TP0VBko0gK+cqPrm0KZh/e+N5M2guEP/VG
         WMFzV74xFZMDniUmlicRJvmPtxT2N2VcUhMC9xBxVu+j1K/usvY65hZ7lOWP1kW/NmlM
         ts3a5C1qTRTYOcWSwqP5yw44nowhB4eRpmx+fXo33ooE7BLFgz40kHD042ZxiWYk3LxB
         Vphey4VwrOKZfgC1Dm+EYVyz6+l+e65PxnjN44vBQ0ik5OXvsQ4GudaOZItzRzjN02M/
         Zb5eSsDGm2VJpIE0aJm2kQMZJhIvWvnS7MGiKxMavPnB3Fx0bE2lINT54R6Yzw5kynax
         8XaQ==
X-Forwarded-Encrypted: i=1; AJvYcCXgbX3OYLqVX9l37qagjeC3WCNKQoGJHMYmOy6U9+PnrUxeF0zS/rGPz9CvGUer3uGf+5JhGvW7RA==@kvack.org
X-Gm-Message-State: AOJu0YyfBbFPKrF5RysbQV+sp5K4e/WVfGkFWKtlcpBbfwBFxJgbFR4R
	m7wAI0jBnxgFethvJNRn57ZqZnA/f27Zqp8W/DTVeso0ruxr1LovT13U4Q2VXt8XfNboIvSHb5r
	Z123p//hf3ggDBSeMzg==
X-Received: from wrd12.prod.google.com ([2002:a05:6000:4a0c:b0:435:9538:ee5d])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:c0b:b0:436:19b1:c15a with SMTP id ffacd0b85a97d-43619b1c171mr5602426f8f.21.1770288709279;
 Thu, 05 Feb 2026 02:51:49 -0800 (PST)
Date: Thu, 05 Feb 2026 10:51:30 +0000
In-Reply-To: <20260205-binder-tristate-v1-0-dfc947c35d35@google.com>
Mime-Version: 1.0
References: <20260205-binder-tristate-v1-0-dfc947c35d35@google.com>
X-Developer-Key: i=aliceryhl@google.com; a=openpgp; fpr=49F6C1FAA74960F43A5B86A1EE7A392FDE96209F
X-Developer-Signature: v=1; a=openpgp-sha256; l=1997; i=aliceryhl@google.com;
 h=from:subject:message-id; bh=u7tNOSUp16XQ9Cw8SF0QUGSikFb1+CWkD1yI1QkYzoo=;
 b=owEBbQKS/ZANAwAKAQRYvu5YxjlGAcsmYgBphHY5pD8xrMoCMSi7/YAo0zBpNGTkGFDOlicJv
 SsWF7lHACqJAjMEAAEKAB0WIQSDkqKUTWQHCvFIvbIEWL7uWMY5RgUCaYR2OQAKCRAEWL7uWMY5
 RvK4D/9Sqg7OAbaqsJt4VhIwElaxQsfFl0bkBDgM9NE0JgEtF//U3IWNLFyiDbFjyU/eYNk4vqA
 /EoImWS8mnYl49c7B4DXLibsoNeVIXCKk41En9QlYRydj2O+rGS4BRARaos3d5GjPSmcd5W/WY3
 JlN5F7KIYDwQtbzfPsAucG07Nj7n5ooKrD9vFmhSUlQOWltfSNAyris0RP0nsl1k//en5nczqcN
 Vls40YLjS1+M/48o87Ba3YvvlYh4DUWI2J5AdR9/ty4DwW+6LUYqAGimnOQ9vT1wZwyFqKs/5nV
 usl0vrnOojmKlNEIKXAhY+2Jv94Ssv0sX3Ngw5CLUFOCvPfiyzNHu609QvruEX8SKNeqwadY9NS
 YeHUBm0PnQkjoPqhJZmFyAdz9Fs30oPy9KItXYWvVWiggE0bDgPE0hsZX2WyOxOXk8z45ZYDY1L
 h4IUhPo4C9JFqzerdHy9DKCF98umsdKRVGW3CC+osSf91NbYzBFxsNQTTVNLm0Kj4WbJupA5VZY
 TAgoS3a4p2E7fv7C/DDR8exECeiis8FHGKgaP41bzhBB3p7kP9Z8L0JR1j/tZvGv28Hh0R7HOJJ
 XXjDToIdX6vm1owhmFCg8aoVz06WZ9aWdPGYaSfEgHmo2lybieLTgIshWP31cp0hOUQm9tffRSO VAuNvPd3riiG9ww==
X-Mailer: b4 0.14.2
Message-ID: <20260205-binder-tristate-v1-5-dfc947c35d35@google.com>
Subject: [PATCH 5/5] rust_binder: mark ANDROID_BINDER_IPC_RUST tristate
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
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B3D591C000F
X-Stat-Signature: mqxigixuewfbsubc3fac1prw8hu4xkqn
X-HE-Tag: 1770288710-481958
X-HE-Meta: U2FsdGVkX1+WLmxTdDBo6yMkoJFE9+IVLNhYfwCW+lX2KHe/uVkRRfbR+fuO5FoLRZhIHk+598To3ye81F9tGXfKpshcPk8Kqu6b4zojL5WFgkoImwe0Lm29rQ9ZA2acFcHmGFDBXRUxzJjLnIKpXTbZAGBVSERPf3J4KM5+78GxWntU1pLnw88cvQJfO3YxsLhlrAk4OCsu8CrbEfFkURJSiMF7ciXNbF2hTH+B16wbJgeW66KlICZMlHBRx9OqJ8dGNv7/p78M94aRjX9I78vzzr7fN35jfxLSjU+0N2jodBUh8AyFg9Q1D8/W8OJ2ABxvPNVtiY4mxgLyjlHZXdcVNEKmPi2ZPapcXGAeDSQeXd2WTrfOwniSjwLshpxI4ePtlbB6AAeiX+wlN8hj5NL9KRTet2zoLSlgOCafyBzdI8a0OV9l9nJZGd+0caAerKS98KaSDgjKEVfdbVv2C7642001ltaHY4zADH7xQKgGu+QDMnEj2QMn8DRydof2cZCNzllEb8rZxBp3wN0lusMDh/1hUQ9wqqcDBEGEiSkRLBiBJhBORTPs6CgufCLOeVkLye6130HsOkM4RQVyrwlO5v0AFfLKZVbDalpmtgDTJKZQWDfO51oU44ibV2PeFoJb2m3qEvuhtX/3fBmdDqduqmlpgEilSu1Er1X8DHc31OuFSdPBYwpJlfr3iKkiBDX1ebyg4lTxsxFUsK0bW7XemzvqXFSMOCsmJgHwHWtvMUzl3eicaaKB2ulAaN+LyQTtbBW9y7J6y84/YoGVlrVdJrnLXt9i5XHgWBEHpA5NaXa8/kkYm2E7PwDDfNZkykbWjl8x/14h57O1WeP1NxpcTDvwMEQMWOsvHur9z36pZJ2crMuLc0H40bNGPzxHInYTgrNRJpGdS1KxQ9uMK2hl1zOrlRt9Plu54PoSOnieJTGRD8zkhJQaHGJcjVLeberDGfh/ulRhy4OrygI
 yIsCa6GH
 gpoyHRZQBRog/HYds8EXptF3Y4+Iv8nOENzfpPzwSbHexCEY1sL1bwgmr+ahLD9E5XANlx7c2D65s/W6nOq9daYNMqDxV7fxHNOYfKhke81RdQbTfEcUsnVRPuEAiZuA8rga45XKwfPfwK4Oga0A+bTvaLtn2xTNG0PivEyatelDY77l400j9UcrfZqpvMcGeQo0/uRDkNs3zvJ4Qm6KldQkW/XXeL5ojZRPebxkSJLMxV0/KM/4ik5ih7YMQWRNua7PTqMibyVdm3v9SaOSC1yGQ91XfG8GEhal9y0V1AwuzDRet8gqhlfmVwqaK1S23WA6wb9S5Xm5YbWTCUDRlspR2JtZtK6ZYxOt+m5xxVCCORfbr04DC0nhMVmOagWiZZAApQMw5x5vbEr5qfU7NrHG/A2e377tfkTxFfyXNWCPtU5eCx1b2w/YqZMf/8vHtTyiBRQXljwFuxAahaZUDrzAKBR/3GwKADEBEbhKK1LUAe/elzYt3osUrN6TaF2edEm+nTz1a0E0c9Vp1QpfEpDvDYPGgMy5uHE4Uc+Ty08idKRjhkcB83PjqaCgiJAXAcFEXQfossvGDhJnaMmShkTbv+ZnnmwnppkrYZJ7PdCyY4LGcFShlrAAg/1sASwWmBuE/eO+U/DAKHitQBjxNN0nQ0UUtcnz/SlY58VgGdjP0CwfWVh4kDNUOxg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently Binder only builds as built-in module, but in downstream
Android branches we update the build system to make Rust Binder
buildable as a module. The same situation applies to distros, as there
are many distros that enable Binder for support of apps such as
waydroid, which would benefit from the ability to build Binder as a
module.

Note that although the situation in Android may be temporary - once we
no longer have a C implementation, it makes sense for Rust Binder to be
built-in. But that will both take a while, and in any case, distros
enabling Binder will benefit from it being a module even if Android goes
back to built-in.

This doesn't mark C Binder buildable as a module. That would require
more intrusive Makefile changes as it's built from multiple objects, and
I'm not sure there's any way to produce a file called 'binder.ko'
containing all of those objects linked together without renaming
'binder.c', as right now there will be naming conflicts between the
object built from binder.c, and the object that results from linking
binder.o,binderfs.o,binder_alloc.o and so on together. (As an aside,
this issue is why the Rust Binder entry-point is called
rust_binder_main.rs instead of just rust_binder.rs)

Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
 drivers/android/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/android/Kconfig b/drivers/android/Kconfig
index e2e402c9d1759c81591473ad02ab7ad011bc61d0..3c1755e53195b0160d0ed244f078eed96e16272c 100644
--- a/drivers/android/Kconfig
+++ b/drivers/android/Kconfig
@@ -15,7 +15,7 @@ config ANDROID_BINDER_IPC
 	  between said processes.
 
 config ANDROID_BINDER_IPC_RUST
-	bool "Rust version of Android Binder IPC Driver"
+	tristate "Rust version of Android Binder IPC Driver"
 	depends on RUST && MMU && !ANDROID_BINDER_IPC
 	help
 	  This enables the Rust implementation of the Binder driver.

-- 
2.53.0.rc2.204.g2597b5adb4-goog


