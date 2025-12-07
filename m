Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18399D1CDC6
	for <linux-mm@archiver.kernel.org>; Sun,  7 Dec 2025 17:41:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3CFE6B0005; Sun,  7 Dec 2025 12:41:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEDF66B0007; Sun,  7 Dec 2025 12:41:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDC8B6B0008; Sun,  7 Dec 2025 12:41:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C91356B0005
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 12:41:08 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 54D795B912
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 17:41:08 +0000 (UTC)
X-FDA: 84193391016.05.FAF167D
Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	by imf01.hostedemail.com (Postfix) with ESMTP id 923DC40003
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 17:41:06 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Os7UkicE;
	spf=pass (imf01.hostedemail.com: domain of swarajgaikwad1925@gmail.com designates 74.125.82.52 as permitted sender) smtp.mailfrom=swarajgaikwad1925@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765129266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=whxb67UcGGca12cfvPU/vL52+fvnHgM4QbrFg/cv+Fc=;
	b=voFryPjZjWlSt7gYeFZRQmYUleUoGicmK2f2kmbcodlztJ8W8dRIIVYr6ZAqeaj8EJKOeA
	fDfsn8Oye5u89APljtVIxGKt95AX3HhJjJbnAQVhY4kRbFWI3kZT5tg09eljRCcsUBGFY0
	wIFrQxQ5kdF7BpYN10uMyFmaqTijGTA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Os7UkicE;
	spf=pass (imf01.hostedemail.com: domain of swarajgaikwad1925@gmail.com designates 74.125.82.52 as permitted sender) smtp.mailfrom=swarajgaikwad1925@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765129266; a=rsa-sha256;
	cv=none;
	b=3Pa94hXMxHRTgEBlPtcC77gTgpuaolLlbXLts9Ui9oeCamsOJpwIkqYsm8tMXapsfdmzON
	tktpxYDzEtGbrMcxhlr+qeAJ7ZRt5SQr7igi7zja7kv73qyE5ivwpnjPAayfB9ir/5TlGy
	KzbHXKMWbMU386YgJ1v4POSDFj2wLsU=
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-11beb0a7bd6so5410433c88.1
        for <linux-mm@kvack.org>; Sun, 07 Dec 2025 09:41:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765129265; x=1765734065; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=whxb67UcGGca12cfvPU/vL52+fvnHgM4QbrFg/cv+Fc=;
        b=Os7UkicE/MXhNSx512+xu3SQ2HRt1BgN7MsZBXl4oTpkw1+Q5RKP1xP0eaHXGGQmwN
         IQgsH5L8xRotn5yYm7ftpepnGvAY5dc4GpJCsezIl6IiCaLduSd/vI349RGzLbSC6Kli
         0VmxXDkhygnU4WZQhs12EiAc18WZTX3yQuHNNvlxoK96IMFY19MepdzyEIua7zu8q+8A
         78VMtH3V2tKMeOsTFu842o0KuhKS78B/A9HBAavRPtDwdIAlc74N7xekTvh1dgJX7BwB
         1lNcfWY9XVMu/X6msXYy9JYgN+9OUb/oTnTivMy95aU37vqyazZOyiAWsmPIbtNgb38b
         sxXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765129265; x=1765734065;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=whxb67UcGGca12cfvPU/vL52+fvnHgM4QbrFg/cv+Fc=;
        b=ORSGP0j/uAXDTzUBiHHGm74erV8Z86qFW/MJD2c046w3+4jSbZ0mfTONbjcFnAh7et
         Cd2gn6a8UZb7GXtFVzElQ2OIpxkEuKfAPQliDbM+aZoKnat8B1KNCLvNn/mHn98ZYISy
         7gBJ9xQsCjzknHWyLJSEkCn++MN+GG6DGZWN3+lUhxt9nOfDSqlGIGqlQrqWtFfM55kz
         1lHcT1FUiyJQy+ta+Y5ywmbDuydx46HuijnAt30qGR3n5EubIvOefiW+etaYC+q3mcEa
         hdrjTUtRXr5mb+VpkqQqjCrCXHcgdlhUBH3EVUYhb5f+WUDtUmatQ+PZG58DvzXyhmcW
         ptXA==
X-Forwarded-Encrypted: i=1; AJvYcCV8MGrybEMfqNiUKVjW6KLMRohGgmB7q+Kv0VN7tgJdDDfYBBHrWGl6sQTY4u4OV/BxpzZ7/UzHvA==@kvack.org
X-Gm-Message-State: AOJu0YyoGxc0LT7rANQdPrG5n0kVo3lhSruUs93x69RPJl3TMh/hJadB
	T4CHYeHs+82663rSjfG98roeedaaj2H/K2M8bedQvIPoPdr9wJmQkfO4
X-Gm-Gg: ASbGncuWjshXorIYfyEAzJrzL7XZgawwKCt99tpDmbUj3ydGYlPr0VQ68Br5rPikMo/
	JUCoXVJvGEgucBSiDPD5DjdiEyFEJeZ+TF3MsN0eSh0fNtvdeH8peUXwvEqp2mXeWTjIhoyfLRb
	jq9+lENRupszEJAnD/uICKET791m7dVWP9b23MhnvwTuF4y5D28muAchEtQVXBCHz+m0cObd/kx
	Z6x5YHrLKGTmhMbWaV+RyS6uAlfa+HPfO+2mB0eKHemFlW2oLauFPa9k2/7eQYcm0r28+rGqT8C
	lk8hgscCanCCw1nhKvWRDUf0sIAkEdEqsKcCY1rtnf2qUlEGIV/Za5VdQSjmQtiuNL84L+8mZjr
	HbgTKAYZvctTEbQj0LINqbScv/v8Dd3j1HnvfAMY2Ez4kXayuGJdzdmlmLkhxQECGfcLhv60ksZ
	xsg3iiWp7OWqWTfIckQyv02pminAb91A==
X-Google-Smtp-Source: AGHT+IEMC2R0NH/AI4id++VBSsDxh3zy2e9blcW76dynKBibhJqIpLoOvbphSjdEicSeZZU6tUmzYw==
X-Received: by 2002:a05:7022:f10b:b0:11d:fd41:62c8 with SMTP id a92af1059eb24-11e02f4a14bmr3734161c88.13.1765129265074;
        Sun, 07 Dec 2025 09:41:05 -0800 (PST)
Received: from LilGuy ([2409:40c2:1164:c0de:4649:c9fd:244b:6ecb])
        by smtp.googlemail.com with ESMTPSA id a92af1059eb24-11df7552defsm44403088c88.2.2025.12.07.09.41.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Dec 2025 09:41:04 -0800 (PST)
From: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	david.hunter.linux@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	osalvador@suse.de,
	skhan@linuxfoundation.org,
	swarajgaikwad1925@gmail.com
Subject: Re: [PATCH] mm/memory_hotplug: Cache auto_movable stats to optimize online check
Date: Sun,  7 Dec 2025 23:10:56 +0000
Message-ID: <20251207231056.71294-1-swarajgaikwad1925@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <7cf016ec-70e4-4244-82f6-32718dc38cc6@kernel.org>
References: <7cf016ec-70e4-4244-82f6-32718dc38cc6@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5hg61nfrz37yqqadz41awhk8dshrda8b
X-Rspamd-Queue-Id: 923DC40003
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1765129266-895252
X-HE-Meta: U2FsdGVkX1/ff2fwYNYfimQcnx61BI67QQ2oapYIqBQR5K7OBOBOo3T0u7u0dtFYZeSxBWXYmdmSM9T1bXtKqVglF+6KNQfw/ELSc7whxpnL3pSGo7wFFGlFh8Of7V01P6xglar81/h2J5HAHRQQL5Qr5715rWOgnVnrtwpHcYPdZ6o5LyJM2zJ5sTJCf39dXqwUZnnUStcbexQV7CubLRTW9RD7tCFNf0UcibmgRqf8K16jDOvsdqC9tUFoKUiysTJJdvkIw7jZ79iCGgcTzqpS1oNsN7pdwNfdg006RCZEtJ1n5SxZizCceZZWYSUusUGJf9TjcF6UCP4iOwLmInSin2sENAXDNZC8BGwSaGIjSQQV8Hy5wE7rXa/BTVIiP5v/IU8p/9Mg4JizZ+YXVmB/KSEIlfYUaFmdheKiqB+VbpUYWbRtQjJWzWfHpHPagZpMxOaqRXVrN0ezKEGAYHIQIAEg9R+gTg5fNALXqpIxBTe24Rud0LH6CPw9ARJhjw/aLM0lPh/xDZ4DELOUaUzXLuxBXndtUxVDzTeMzSXcudlmr3Dc+MXyN/AoS9vvVx+xCyhUIy4T9UcKqbTHxeXwuhrRL6YPdtNC7k8TPpmz7iDvBkprtkPXm0ITw5jlX5D95nOeigDbuRdraoz/LuunYgpnPN+EfPSK/8YDFaFk5Zp6Z9O0jrvcr/oRHPDm2YDXc1M42fr0Wpa8a9aSp9OI/rjbGfNHfX6SohQe2wH+vvS+a8lbSlpC1stTPsIKdFoOonm+5rYIb7nhf9WKmG6UX+z32AT8044gp6Ht8sFITWaxuQTKAhwtzFE6I9lPKA96EZK8tS5qBUBy83dFhTw26J+3maWC1SYLqIcIbso2I+x4HpLIitkO9dZF9VnLWoWykEoGdQveBOuv85mfwaeNx2e/v6d/aWQJ96cq0x7eESRMN8FKM7eIiAeuCzupHdNtf/l3SSLi8ZgjUV5
 oKOymQvL
 JqH61wnGtd1qVb8L2clrxmpJSjmH6tXP8xoE7cqWVHRDifUin/Lu/VCxpnSMYx9kN5Zrg62ezFOD75sP+HHEB6JO76jZn9TgiJkLeLz1PiCCvE6X9J6aE15C6leh1IUkvU/UA9hDASjaoTpSwjqLFzUfKaVcnjm1ctfeAJWhhRPUoJhQFrSvEkPdHz2hFpdSgjiGB/QVJJT3tRGY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

Thank you for the feedback. I've conducted benchmarking to measure the
performance impact of caching the global statistics.

Test Setup:
I created a QEMU VM with the following configuration to simulate
a multi-NUMA environment:
- 8 NUMA nodes, 1GB each
- movablecore=2G kernel parameter
- Additional hotpluggable memory region via memmap=1G!0xC00000000

Benchmark Method:
I added a debugfs interface to directly invoke auto_movable_can_online_movable()
with NUMA_NO_NODE (the code path that walks all zones), and then
triggered it via: `echo 1 > /sys/kernel/debug/movable_benchmark`


Results:
Without patch (walks all zones): 2402 ns
With patch (uses cached values): 453 ns

While the absolute time difference is small in this test setup,
the improvement becomes more significant with:
- More NUMA nodes/zones in the system
- Frequent memory hotplug operations
- Systems with many populated zones

If this performance improvement is not considered significant enough to
justify the patch, I'm happy to send an updated patch that simply clarifies
the TODO comment to: "cache values if walking all zones becomes a
performance problem" as you suggested, for future reference.

Testing code:

static int benchmark_set(void *data, u64 val)
{
    ktime_t start, end;
    s64 duration;
    bool result;
    int nid = NUMA_NO_NODE;
    unsigned long nr_pages = 32768;

    start = ktime_get();
    result = auto_movable_can_online_movable(nid, NULL, nr_pages);
    end = ktime_get();
    duration = ktime_to_ns(ktime_sub(end, start));

    pr_info("BENCHMARK_RESULT: Result=%d | Time=%lld ns\n", result, duration);
    return 0;
}

QEMU Configuration:

  qemu-system-x86_64 \
    -m 8G,slots=16,maxmem=16G \
    -smp 2 \
    -netdev user,id=net0,hostfwd=tcp::10022-:22 \
    -device virtio-net-pci,netdev=net0 \
    -enable-kvm \
    -cpu host \
    -initrd "${DEFAULT_INITRD}" \
    -kernel "${DEFAULT_KERNEL}" \
    -object memory-backend-ram,id=mem0,size=1G \
    -object memory-backend-ram,id=mem1,size=1G \
    -object memory-backend-ram,id=mem2,size=1G \
    -object memory-backend-ram,id=mem3,size=1G \
    -object memory-backend-ram,id=mem4,size=1G \
    -object memory-backend-ram,id=mem5,size=1G \
    -object memory-backend-ram,id=mem6,size=1G \
    -object memory-backend-ram,id=mem7,size=1G \
    -numa node,nodeid=0,memdev=mem0 \
    -numa node,nodeid=1,memdev=mem1 \
    -numa node,nodeid=2,memdev=mem2 \
    -numa node,nodeid=3,memdev=mem3 \
    -numa node,nodeid=4,memdev=mem4 \
    -numa node,nodeid=5,memdev=mem5 \
    -numa node,nodeid=6,memdev=mem6 \
    -numa node,nodeid=7,memdev=mem7 \
    -append "loglevel=8 root=/dev/vda3 rootwait console=ttyS0 idle=poll movablecore=2G memmap=1G!0xC00000000" \
    -drive if=none,file="${DEFAULT_DISK}",format=qcow2,id=hd \
    -device virtio-blk-pci,drive=hd \
    -nographic \
    -machine q35\
    -snapshot \
    -s

Thanks,
Swaraj

