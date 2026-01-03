Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 772E9FC6160
	for <linux-mm@archiver.kernel.org>; Sat,  3 Jan 2026 20:06:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E6F86B008A; Sat,  3 Jan 2026 15:06:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 395276B008C; Sat,  3 Jan 2026 15:06:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 292FA6B0092; Sat,  3 Jan 2026 15:06:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 163606B008A
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 15:06:49 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B9C5B140823
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 20:06:48 +0000 (UTC)
X-FDA: 84291735696.09.45B1D17
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf09.hostedemail.com (Postfix) with ESMTP id AC57C140012
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 20:06:46 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=delta-utec-com.20230601.gappssmtp.com header.s=20230601 header.b=j1fzuk3C
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767470806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FxoKlL/Oxj8cjXiUa8fJQ0+WnkWJvGDujzcDraVgeM0=;
	b=C8DjPumV4QFmhvf2+e8BwzQVsdwfeMKN9wgP94QC1OtR0kafJYnnIOI7Z1U6Y7pNGQ3UdA
	BT+WbCyinFUUgfD0g8/gPGxdSen1zMjG1qtZmxX3fGuaeK+WpFmdDRKTVzmR4rharkIqi6
	9EWkg88NNHsH91P3k2K/Uhi5VHvzpVs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=delta-utec-com.20230601.gappssmtp.com header.s=20230601 header.b=j1fzuk3C;
	spf=none (imf09.hostedemail.com: domain of boudewijn@delta-utec.com has no SPF policy when checking 209.85.208.50) smtp.mailfrom=boudewijn@delta-utec.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767470806; a=rsa-sha256;
	cv=none;
	b=NGVwwiOezaJEel2ar0L3RCWZMbv77K8SomtMvMpGlcHVT+7RXMzssJ1hpTvRkXNdqxp453
	U71rwzmKP7lTwVHnE1v1PTjFXYXDXpqpKlepMQs+yotk2EPyarzkGJKqJxss7VKWy/d3md
	DBOPcvzhMdJ7XlC7t4pEgfPWkUmfQ9k=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-64d02c01865so17691437a12.1
        for <linux-mm@kvack.org>; Sat, 03 Jan 2026 12:06:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=delta-utec-com.20230601.gappssmtp.com; s=20230601; t=1767470805; x=1768075605; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FxoKlL/Oxj8cjXiUa8fJQ0+WnkWJvGDujzcDraVgeM0=;
        b=j1fzuk3Cg1Vn98R251tJ6EY2g+BNqBUKGhi8mfUDrjFXOsfu3eZyJs6uhsA+LeHENQ
         iiYO7B+ZgyiSFKxvMFPGphD2SLmrc5x2x3gQZwYGvuEu3nSE4zqRiuR8QooG+wYQt82f
         Ut0reFHUn+E2pRQQUdTctWE8U1G6dK49VPV61wNBRryDYDi0zl/yWQe39I96a7dAyqUb
         9eo/9jd6bv0cUHr7d1BKFQvj065ctpr8BearLDrO4282t77bx+kfz+NFkwIaDhYs1Kw7
         zFR9RGQA24ejmzXAkSbFy0hMk+pIUX5e293C2LIyG4yFA8aGw03j3wCGZ05yvXwmhbMu
         xNtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767470805; x=1768075605;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FxoKlL/Oxj8cjXiUa8fJQ0+WnkWJvGDujzcDraVgeM0=;
        b=UKqNNRK1oafHM1QzbVyX1/8PFmKv/jEVx3MvE9110bF3muku7cy6oAYiESusrYNYou
         LJj4uKKkRWO0VF7n6R4e9DJb73HOIfG0UJB3j41pudqjJg+xs1Y6Ml4iPZOhtn5h1kzw
         J2A4Ix4xg05/2JZi+lOz7nTTYnPv9ZQoMeKZOuXmnHBqw8jMb05J29EdoN6Umep3Kcbs
         XZgKvTr/pIUudzZM6MPHtItIJUI/fPBy/4KHLlKztktHEnHE4jRvbwgnNr35GTz5URY5
         yW0pl3iLoRJ/SvRFN6pAgmywVUC5Fd/wKzxjO2onmrN7+tWDaK5llX1kvYeWud0+w3ML
         jPkQ==
X-Forwarded-Encrypted: i=1; AJvYcCUQFSWDaKLD1ea7b4OWJAiztuChFl7xdFF9EuLsa3+NaMq0GO4nDGPghI3cojMz556sYjjNH5pV+w==@kvack.org
X-Gm-Message-State: AOJu0YxynAahSpNPqSjKnkcFJ5V8u1Tk96NEEiLqLRBLiWd5GmFgXm5V
	kXoQ7g5VF56fHTex6NvgP9XxIgIqxdpAA+Xm7qGcQuw1Dq/j5xxPx/4Jn0UHW1TJ1A==
X-Gm-Gg: AY/fxX4hVFPwGzNPk9AE+NVQDE9yaogCJHtUyq32t1FFK8H+fWuPiNXySmTIsXzzaJx
	N0RZHlckJrAsccohA68k8V3ElACZa5B52jKDLmPqofx+TIM/t9PrvhJAT57EdEkOqE97I55UyTW
	F8uGxsIh1I8S/jLoeUcrXO6U9bh4CcOQzMtBzrjKmtMpo9Y4fMIq8gVoJ34HU7eh8TxfJJ6MdPH
	TAcoha0yssfdgSDhiHxnOSDKk+2jM3RkfKKoQdUIiVl3pk0tCYr9KLXBoeVV91hMtubSaSEWPG5
	SBq+slGjhrXOteqKR0+e2R5i01+ICTKq2qu+lOky8AeuuIlP+a57UCKAb3bf+KLn/7qgbGn1n0V
	lYuReKaR7+SrxSVDLtUpry2vfTC3wgUW+WDCNehhwbQv+2KTrdMpuVev6lIC7xJ4QqBEinlEgUy
	ql4SfPAabiD0Z0sm4ooO4iXg58ZIPb51G7kO7uu+1kyiXe35sRqi9I6bsTfbMTmWfCzp2FbPyiX
	By2KTeCOIw06nxhk5u2z10jUufznhpN4K5fX5k7
X-Google-Smtp-Source: AGHT+IHfoggmh0JhJoli31xUldbGfugvSYOe/aHV2oGOtcQp4I/Qk05UR5/AmmfkN/yM1X0DIZGwgw==
X-Received: by 2002:a17:907:9347:b0:b79:f4e4:b544 with SMTP id a640c23a62f3a-b8036f5bb20mr4565488666b.21.1767470804883;
        Sat, 03 Jan 2026 12:06:44 -0800 (PST)
Received: from localhost.localdomain (2001-1c00-3405-d100-e1ff-2c8c-c190-2ee3.cable.dynamic.v6.ziggo.nl. [2001:1c00:3405:d100:e1ff:2c8c:c190:2ee3])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8037de11dasm4948022466b.35.2026.01.03.12.06.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Jan 2026 12:06:44 -0800 (PST)
From: Boudewijn van der Heide <boudewijn@delta-utec.com>
To: akpm@linux-foundation.org
Cc: Liam.Howlett@oracle.com,
	aliceryhl@google.com,
	andrewjballance@gmail.com,
	boudewijn@delta-utec.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	maple-tree@lists.infradead.org
Subject: Re: [PATCH] maple_tree: Add dead node check in mas_dup_alloc()
Date: Sat,  3 Jan 2026 21:06:31 +0100
Message-ID: <20260103200633.246006-1-boudewijn@delta-utec.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260103103247.9140cb2556280927b09f59d3@linux-foundation.org>
References: <20260103103247.9140cb2556280927b09f59d3@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Stat-Signature: 85bxeaa8mas587ny7az9z94pko6b1w7d
X-Rspam-User: 
X-Rspamd-Queue-Id: AC57C140012
X-HE-Tag: 1767470806-107739
X-HE-Meta: U2FsdGVkX19TXMuBKGzd13TYOd6j4UCA2aQ78YDjSKmsRklyWlZQkkRt8RY7Dbubd1PSRcL3s7xwU7UFvX3NqjtobCcyklK1Do9lRZmAKC6Kvi91QiAyG+Ge1cZJSmnTpE/gzO/6+isJY6a3EX4ABSZzUm5Qtj4bttu+mI0MKGHZWRzSjrMHm4BxqlRD3EkhkLKaoL2/KeA+wGMU5raxDi95f5fRBKi/+6mhraJhl9B07peCx71+Z93275XV7LIqhfRc5FTbKaWjaJrQTuYitSOf5vLqrOk4xCB+djXKt1gVBof5uSg3rq0ZdqXGmWKXO7AKwdo5OqVm5lHxtwKW7eeNN2GKAOStkUPirnntpQ1bHEVbfYaOcwL6XFzmPXH2p5Y1Gp7zg1dlQ1V05mv7r2Rsk+CnhpT1CtCkIl4UI3lDBBe43tWKuX24rNVybQY/MlUv7pVnarcB/+NtRV4/lKkw0v8qFyHzyeQ/ZQqZntIx96vMsztEAIx0xJE89VYYX3ISKDiVcDldL1c1DKSzJwFtgZedocnFhq8I2AkUTSE63YMX3N7sDz0NU+YpqYaD57P5paoI51S7x5TfqAXkOUd9v0ht1pCt1od8gC7Kx5lYcgPmB854zRQQJRvJFk+RPe22cdcTu4evSUToA9Zf343OEo2q7+ygjj1t7tIkcgBoPR4CZAXJCzkVqfSOtfmYumW7hKuFhMqzlmJT8gQwlKU4ip4IF2nODHdtS1zUEaIzyUW7NHeEVHVBS+OPzcZd6A8DwJ/j/TFweAQW1AJF3VFJavn10dTphi7OK+d0mKO0+++URK2B6/P4400YOumBf1YKWkeKMS5W8sjwckaZ4zdiB/hsjnHBRVeMwEd/F3g0Y0MfMx0j8YsNoUoZD1JGQKVuVBbLN20WbiYuccAMQhrGQvJuCh6MT0xGKo5rKs8oZM5ywSLXjeI3yih975YUM9eT2Wh63Hwu54M3QvC
 vfEKDz8y
 88geql3BpZGZOrCxH/gGgz4WDoN4nST8WjE7Ph4hftTRTJFCos3jBTIghoniML8UEAYy6yw6TdpAMQCbnoOEGtQSq9TT1ojH+bjJ+U1JaFCizObY0q2gVc7wP7YtWxnZJuXMzs8GI665umkZc5627IXxijLvnNMKgyDFPYWZfHQhdPv1cEao5hpE5c9igyFvvEOp5m56QAjReayXiBEZotCK0e9zrFWRC1Nmjs+QH+y/IgKL1AJ1dMhFjCcKdEVkI3S2Nktv4hu23ogwIj70mF2DQ5eRAb5xV7oHCHYBdQevHx3j+OcrbBWGfYN5BRlwcdyDzTxEPwmVuzoOaxQ/mJlfhYO4lwNUF1O7TTvpVwZksfTLji4F/sGCpE600uKORQaz6cIHuhHm3yQ0OjSXN0XSkA+gvUOzw4PzIb7aKYIHyvxfoZXd9erIfp7iaW2aNROzmkOpxvFNXXWSKQKTo6oFDHnuORC2XkFzp4mBE66LVS/DQiVDRZ7tYbQukNHpcN1Z6fjL0oxFmwfMqoUnqE/Ny+A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 3 Jan 2026, Andrew Morton <akpm@linux-foundation.org> wrote:
> What are the worst-case userspace-visible runtime effects when this
> happens?

Worst case: if __mt_dup() is invoked without the required external
locking and the source tree is concurrently modified, a node can
transition to the “dead” RCU layout while mas_dup_alloc() is still
traversing it. In that case the code may interpret the rcu_head contents
as slot pointers.

Practically, this could lead to invalid pointer dereferences (kernel
oops) or corruption of the duplicated tree. Depending on how that
duplicated tree is later used (e.g. in mm/VMA paths), the effects could
be userspace-visible, such as fork() failures, process crashes, or
broader system instability.

My understanding is that current in-tree users hold the appropriate
locks and should not hit this, as triggering it requires violating the
__mt_dup() synchronization contract. The risk primarily comes from the
fact that __mt_dup() is exported (EXPORT_SYMBOL), making it reachable by
out-of-tree modules or future callers which may not follow the locking
rules.

> If they're bad then presumably we'll want to backport this fix into
> earlier kernels with a Cc: <stable@vger.kernel.org> and, very
> preferably a Fixes: line.

The function was introduced without the check here:

  Fixes: fd32e4e9b764 ("maple_tree: introduce interfaces __mt_dup() and mtree_dup()")

If you think this warrants stable backporting as a safety fix, 
I’m happy to send a v2 with the Fixes: tag and Cc: stable@vger.kernel.org added.

Thanks,
Boudewijn

