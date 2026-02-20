Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7AF0C54FCC
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 09:04:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C63566B0088; Fri, 20 Feb 2026 04:04:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C11966B0089; Fri, 20 Feb 2026 04:04:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B10276B008A; Fri, 20 Feb 2026 04:04:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 890646B0088
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 04:04:15 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1BCC11CD95
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 09:04:15 +0000 (UTC)
X-FDA: 84464248470.02.741FA67
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2E0DC14000F
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 09:04:12 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PLo1juoN;
	spf=pass (imf09.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771578253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D5rqp5/LMlutKFq9RqH8wCGMwu3FF0r+r7Qg7MgU5z0=;
	b=RD0oNEzJ1qmsCBx5PT8JJ27oYJhfBF06uBoNdY/ci/1WGZW3LXgeS4VouyFy+ZDrZ1mCWL
	kJbtBq9lifPHq7kQVSCrlgDAf4NiRc/WBLs5l58KK5zeGV9ZUD+ZWSIc0CIbfkCydnXtaW
	8quixk2+xdP4i7+GgutnNVR5mbmwdpo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PLo1juoN;
	spf=pass (imf09.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771578253; a=rsa-sha256;
	cv=none;
	b=IivcCPoLPb9NvC7IT3YIzfZqOqtw3V9p7HfL4WDZ/meusHPhuLnjUEmtPC6pv5JCzhrNBo
	QYnTrhaMaKhuAsQHyIkkaxP+yASfRd8c/yN34XZtXBN9qmDUCTtHhYgiUCr2XCiGsFfyac
	/zkQ7FL+SV6z7MHIRkgACZhpUioSsSs=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-481188b7760so14847585e9.0
        for <linux-mm@kvack.org>; Fri, 20 Feb 2026 01:04:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771578251; x=1772183051; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D5rqp5/LMlutKFq9RqH8wCGMwu3FF0r+r7Qg7MgU5z0=;
        b=PLo1juoNlXlbtBqkAJdJhQ6i1Uzwfclli4r6Um2uyL8cQXquOzL59TwEJO909ezbfn
         Klo7M0cSl+YfVAKe2qwCRcRrgVxC8j6ihyXwddv26ZmpYxyVSA4JfvnC4+T3VJmWtNYR
         HWE3Bm+c8zGXkJFwjsoHIRGMCZt/aHOCwxaQVjxOxh3MAjf0UVLJHTGvc3+HWtwSUyhn
         kMV4xLxJwwyMpg9cPdYKNgVyEWcngrPn7j1dZkHDAMjyWmLb3Y+wRnrDKfuEAnLa1w3Q
         AHhmqdMRPr01HnBRJLJvraixGzmcK7jGTMmjOHAEZEmCkDRa7Q6NgLdRllQ852P3c0yO
         ILiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771578251; x=1772183051;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=D5rqp5/LMlutKFq9RqH8wCGMwu3FF0r+r7Qg7MgU5z0=;
        b=cz+SUDvk/LHhei0viID3haXMArVnN+/U1YANm/wz5+xS5pDHnWwj+aWKJhwXJA93wN
         a4UcYg9BcjmAtUJepssTSaJQah6vgwHm5uKg3sE4MXnDUMgWwAlY2fX1LD7mrfarACs7
         pF8H3P84W/2ps/kZIQj9bpWeqUmMMbPI5Iej0IOoUJ8gBG2lqNlbTfuULZpWcojZ3pDU
         KX3r18J/LUh6eefBkBYOTr2x62Q/bt2UOXOk/CZ/DyiC+zlvPtKvYWpR/qUWGfcakg46
         WrcC9+OJHwaDF78A3x9diZXVmG8oREruMFJe3IU+z9+7q9yHwCNZdQ3nxV2LGLeVL0F4
         5Gog==
X-Forwarded-Encrypted: i=1; AJvYcCUMvMesWync+cEHz+XeBViQpJA89YGfWwA3OOunZGJ1K85j+2n0RK4chWMPrQdt2jKiB7nigkwfgw==@kvack.org
X-Gm-Message-State: AOJu0YwUZBGfp+mIKfRONoxDsuXsplbftT0DGfRENv7GKvXHTG1IYuig
	dnJmRxBKmfvJXALo3HrYKxHb20zFL+IHpVqLep42zit9bdZki+s/eAFA
X-Gm-Gg: AZuq6aKAtCNbskRhBbXDN/JnwDM6F/BU7CMeysx4uDv9OiLvOXYjseewzw2GRX55mVL
	7L5kfKBMl/iYnRzVz/JdYpfsvM9iVwQ+OiOfva5xjuvVknT7nrqz+Gvbn6hJuu0jrhEkz7x5kRe
	LbCOZAeEh0qKheymOQUiklo5XYVAjrv78ZuCIXqYEHOw7rXMpQJ1Ypr/GzdQ6LNQziGgrrzkITw
	SleQ0K9c8aQLNtyDlCRj88Ajs5yLOSFKnAzqZ3SsL6ntkDA1Ksl6zFDPhx+GhzBH8KhGx3twzxy
	0VU7/GysLtFlXN8fKr5jxh1oIimtJPE522CbC/fBl8rWZ/viUsvxiotQyIcO6YjxY57VFv8yxt7
	Asecp+0xabnW4S2GoFerTxKCz/OJFMx2G1pcknqQinT/mI1Nam+pZPgmFZbnjQ/Yq/DV2A9lNnG
	WwJEK+Gf5vu8p1WO5L5FYJEiOmZQnRzrPhLK7DQyEHWYU9fGFd+R6l+HgQdhym663s
X-Received: by 2002:a05:600c:1387:b0:480:3ad0:93bf with SMTP id 5b1f17b1804b1-4839e661cd7mr91556865e9.24.1771578251130;
        Fri, 20 Feb 2026 01:04:11 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483a31f995dsm57350025e9.13.2026.02.20.01.04.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Feb 2026 01:04:10 -0800 (PST)
Date: Fri, 20 Feb 2026 09:04:09 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org, x86@kernel.org,
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Mike Rapoport <rppt@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Usama Arif <usama.arif@linux.dev>
Subject: Re: [LSF/MM/BPF TOPIC] 64k (or 16k) base page size on x86
Message-ID: <20260220090409.1784bc64@pumpkin>
In-Reply-To: <aZcmlIF4bmG0twkp@thinkstation>
References: <aZcmlIF4bmG0twkp@thinkstation>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 2E0DC14000F
X-Stat-Signature: q3ggr9mj54jxrntppdqpk3kconead8e3
X-HE-Tag: 1771578252-289071
X-HE-Meta: U2FsdGVkX18ZzmYARbYnTmQtktjqgaZSVS0WLxwFBfA2ZI9BuORlOXUdAEyzqcyxf2fuw1HFH8998qtUpoQfgOjnNkl57bwiSU3Gco7W5DEeYXNhYv3U8Xo3DqjSe8ktu8LS9huJxe1XiLnE1Erf5d/ZiaDqZh5kpScUGH5Pqs7vn5hLRCpUoT5v+HQS5dK0NgK5I0VWEtuF9f+bdjMg3F/a1bYMcCgsHuJ9McgnGt0dXP2lP//kte/n0epCDbaT0t+wrr+kWB3jMC0m8dF4yG/ScAbLJUly5fJpuCQN6zWizjHyyq5UpKBa3NTJEhHPPOTUENItPi2m6axUaobo+lIJH9+gVBAZLw29IUoR+wFFDEZTKMahP/ufi72YujgutmUP2is3wva0YiJUjVRIbQ8APekz3ZuHSAL1EL4jUPZz1vEUhZmVmGNK0NOPzPMVd5bBQQiv639KKGFsguiCzIcl8ji0iNnT8i9VsZ0675UJSUWHmRVbQ+cGQIMYlofk1R22PvVfAndU817ntKZ5BDuLUKMyOtm6bR2eZwOgvIU/DVCMAHS7GiXHzZ/6oxObUXyG7zBftgBl4uB8svSGwhjhJ83pFAA/VCsO/7stzRHd0gwVHvcJpMcP1iAdGFZYIIsC1WJPq4ubacKxfIHPdTT3Kjf6aujQNxilgIvqpQAsg/UFcmqd7EPNAZYLqv6B/PnEg8N3QJ6mYtkTzT7jOXNzeSk0koYYK178RVjrRqFGUVdqjo6uS6/KEUvSsYH9SK7gtjSGouwQZ+iKV++WeyzgXtnZBtK2F9d0Ot4j/sYKOaRwLDg1kfMT2ApehxghSOmYko2ZjjWP4ojfbtmZEtpOOMCG9A6ge2Iv4nQ4oFBLZ85yUK225riq0hPLC3yNUUlXV+wUOPd4lXcufin7XN/dWHP7m3/SZ8r1mWKsNMbN80+gFj0bA/UlpkXzjtLA22jVpQt1lqzs6HvCpzN
 F/32BEVH
 PDveQfQz2mCfQhwWL0Ok2p24kxqFUr8kRDhneoA0ENzwKH1IUovI8s9GSQMMTpwOrdjxMCPq+ZKUYhJxxJQntTLnQPXdDR8sKscFuB6vU6A75CcnFla1T7z61SzyGPbCoxGHCRmRXFNVGskFM2z29bS9gpWU4/mPiFJifjBTYeyyMPUZ7tI33Q8EslkdYRD5G8sS5P35Qy0GUo1KeP6U5IjA5o7qLZroqzNCQQ7JKFTzyOzqxypDv/94F1SHgyxfrqivJgCEIxcir9vbJ033FZOzGRUaWCcSdDOjI2233mrEJ4TwYmweDS3OTngZ0ckvlpNcpJ7tTrQQXN0642NWNZrJkNXJY0Yq6g8MGqn7v9tOpJzjBPuTpWxUekUUyWeXGT0pZsPVOU84nJ9/CFzDUve3nOJ4AH3M75roUMiXlNcwNRoFAqUJjgXUPlzbOhAYfAIQ6GMMXt8fR7aQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 19 Feb 2026 15:08:51 +0000
Kiryl Shutsemau <kas@kernel.org> wrote:

> No, there's no new hardware (that I know of). I want to explore what page size
> means.
> 
> The kernel uses the same value - PAGE_SIZE - for two things:
> 
>   - the order-0 buddy allocation size;
> 
>   - the granularity of virtual address space mapping;

Also the 'random' buffers that are PAGE_SIZE rather than 4k.

I also wonder how is affects mmap of kernel memory and the alignement
of PCIe windows (etc).

	David

