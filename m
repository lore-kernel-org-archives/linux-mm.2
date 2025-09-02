Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81EFBCA1007
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 05:14:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCA068E0006; Tue,  2 Sep 2025 01:14:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA1668E0001; Tue,  2 Sep 2025 01:14:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C91308E0006; Tue,  2 Sep 2025 01:14:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BBA9E8E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 01:14:10 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5CD035C6CB
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 05:14:10 +0000 (UTC)
X-FDA: 83843143860.09.160FEB3
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 83ED140004
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 05:14:08 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OMQMTGd7;
	spf=pass (imf12.hostedemail.com: domain of dqfext@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=dqfext@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756790048; a=rsa-sha256;
	cv=none;
	b=LRIvi13so/xmzJbMOJ/tMt3Vl52d82Gl9h3MwRS195j6drgjQt/r/Jsgf7E/sNkYEkM94S
	JLU34wvWs5Zjmbj+qHSYrNwf+69y3KgNkRjGNH6XNBYHAdiQ8prJlgIMAjmgvzcvvw6r4n
	BkRYstdcquf22PXZaQ931AinelBZY6c=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OMQMTGd7;
	spf=pass (imf12.hostedemail.com: domain of dqfext@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=dqfext@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756790048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mbpx4ScsQnybdTO3kp2Rfx+rkLjFhStVTs6nr7auk/0=;
	b=6L7BZRV6oixX0eEn3wzvZhZO1ZcOXLOpMiVbQOvwebOLWnGhBMuynk5ArYaua3FQ7PSZOS
	manOOMtzmB46e+1Wgb9N1v+1zMA6q3fJaLQy5FwKCyoDEUryhHvg7gKk7KiPHywFPT1H6+
	fZ+qTPFxpk1zegY865Nrr3ESqTqAU5U=
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7727313dd05so159627b3a.2
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 22:14:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756790047; x=1757394847; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mbpx4ScsQnybdTO3kp2Rfx+rkLjFhStVTs6nr7auk/0=;
        b=OMQMTGd7DrgLEx4kKU0DCJXcN6qdJadPBw+mlXe2bNRiewExKQOJjcZp/UD2rZwtcr
         7/EWcKrcazqKietp8jNUQ46O/ad4n2QIBeuD9ajjAjBiRDmDaYLEPiIKL+kET7dCu0ho
         wTmOCxfA6J/lPT/0gz5IZ5DswoQedVR7Ro4QNgLurV77KBySrtbQwg7eXrI1IPiq4Mv5
         8M9oVcqtb/H/B0ql3kp5Tgd1mrvoHavT/ZDlOA+BQNEhTM7+lZ5mPS5iOeh6UM3M7IXL
         m/qx43Bh7q1EvTiOPivB/qGfL6WgZez8IM63W+CSJ2jyrbnWoMnwmWRmGwpkWGiRNNid
         ecdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756790047; x=1757394847;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mbpx4ScsQnybdTO3kp2Rfx+rkLjFhStVTs6nr7auk/0=;
        b=pT6H0/qBMUZQ5whG+A6AyMSaE/z4boaD8eoxGXbB2LM1g04jHCfsXmfYtm18s66Ehe
         6Rs+SbJ4WFj0MjpJLuGzJw3yNQrVQ8llKbqcy8NyKxTaDOKubaxYd6db7wkKZ2ZBTXFd
         ZfO2I9m5fAaKnCW1N7c7o0FpRMOVNGzDHDcQ90jHlaw2Qb6+noK7MAdt4E7KuBRBARMX
         Wdjw6J4kTFr7fANgX8sfqrkx4t+RbVxTMaUwf2G5sieZjg/lMDEDBJeMtPrGvgpZKqcR
         Satqzd5tEEtZ+6bCzdIIxqVnm4bufmWe0mEqLGjLIjkMW0nv9PBnn8iGvcH3zOyrdaWq
         hl9w==
X-Forwarded-Encrypted: i=1; AJvYcCW1jnQ/YFTznHCIjExqyAwr04XgvxUn7C2rSWkJxdnHfVWZTCG4FAy1tCU+W85/ngNeARAPPMmhCw==@kvack.org
X-Gm-Message-State: AOJu0Yy3nlmsL11+7SFPZPONy5ALelXLwUCY+KDs0mu/bTFkBDLrjm94
	JQWwE1orUWLrcnWbFBd0cYQ2s9XYOuMvvJcfwU/4THDjrv4TdHCaptCC
X-Gm-Gg: ASbGncs4wi0pcV5D7HwUhMSkdOCldGLO4H6vhAMfu7kxTEcPXpy/zcGtwO8oEtOkcrj
	AI0HEHu3ScKtGo0wLG4CaF/Tb69mVxIF49V/imWjBqYQqEdHsmtsCvAbFQh0GznbI8k+hqHsTny
	YPnwANmb6aMtM0LPyunfLmZuxTs0kXQDJCDCGI2BO9A4nnfEwm2gdsYxV/GVYnvvX9tK3GZRa8n
	Jh8Cd6VvoQyeUXOfeFr2IG3cmn9Wd2FgWoInRkZZrCceq60KaWxcFTAnYuuLWiq+snIxavQpAKw
	Hjf+rjgw3Cm2YSks4vqspOyFoupT7WNw0WMnxklNIGTSM+HyXFMTqu3j1NEOtmZFw4iCbA30cJ9
	56kgoorzkbbfHYzY=
X-Google-Smtp-Source: AGHT+IFuHo6l2ig5Wjql4h2AooDEhFl0y/v3XlO3IRwDflHdbmC2N/qlZXzQe6jvCKxQiC2fHzN2PQ==
X-Received: by 2002:a17:902:c950:b0:24b:1585:6363 with SMTP id d9443c01a7336-24b158565c2mr11578025ad.8.1756790047255;
        Mon, 01 Sep 2025 22:14:07 -0700 (PDT)
Received: from gmail.com ([223.166.87.143])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24905da479asm117731845ad.73.2025.09.01.22.13.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 22:14:06 -0700 (PDT)
From: Qingfang Deng <dqfext@gmail.com>
To: Jesse Taube <jesse@rivosinc.com>,
	linux-riscv@lists.infradead.org,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Oleg Nesterov <oleg@redhat.com>,
	Kees Cook <kees@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Liang Kan" <kan.liang@linux.intel.com>,
	Shuah Khan <shuah@kernel.org>,
	Himanshu Chauhan <hchauhan@ventanamicro.com>,
	Charlie Jenkins <charlie@rivosinc.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Deepak Gupta <debug@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Mayuresh Chitale <mchitale@ventanamicro.com>,
	Evan Green <evan@rivosinc.com>,
	WangYuli <wangyuli@uniontech.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Nam Cao <namcao@linutronix.de>,
	Yunhui Cui <cuiyunhui@bytedance.com>,
	Joel Granados <joel.granados@kernel.org>,
	=?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Celeste Liu <coelacanthushex@gmail.com>,
	Chunyan Zhang <zhangchunyan@iscas.ac.cn>,
	Nylon Chen <nylon.chen@sifive.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-perf-users@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Joel Stanley <joel@jms.id.au>
Subject: Re: [PATCH 4/8] riscv: Introduce support for hardware break/watchpoints
Date: Tue,  2 Sep 2025 13:13:12 +0800
Message-ID: <20250822174715.1269138-5-jesse@rivosinc.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250822174715.1269138-5-jesse@rivosinc.com>
References: <20250822174715.1269138-1-jesse@rivosinc.com> <20250822174715.1269138-5-jesse@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 83ED140004
X-Stat-Signature: cxzi1sasszemymnyzqzpu9hzd8kfesfp
X-Rspam-User: 
X-HE-Tag: 1756790048-946240
X-HE-Meta: U2FsdGVkX192KzkEPAO1UvnIEGCyFmoWZTvkwT8SIhmntQ7srAPC4WvTCQB1ylCbYAl+uq7qYFL2Q8LPs/snXG/WXywEISTHyMwJdA3zqli1co8S7UMuWjHyKXAhzUSNI14cKeEkQizj3xDCxtFFXKR+ANVa480Ci1aGa2He6RgP25/b5NoiCSmjjGDwkUNlu+i3m5tozmD9sNs8mckXGdQb+Cj2/dztgvAE7pxx8EIDJ7CbaQfQqI/+VROz0gKy6lDm8Y2CUByEQIr1AMpdS1TfNJkO5OHV8vS0UA4uJNjA6XkA9gWaWMhrD4k+qe9oP0ErXxJ14k5WZloyvf6XY0KhDzTXH9RGOH2tsAsg15NPoKXW2G5Ai1bqQhYdk+vHrpYn3BAZO4N+ZQsLzkXnV7EDJOFgsZvxT53LEDLdDhMvpV4JoDH8FF7Vmawd9C956pHIV8kZiDnaYvHZRM++HEyhVGKlCZFmV1OgDKedwmKRpgMLIpq5ATOHgauhjtcxtyBJ7fuYsQgbXNkwDYvgzmDyYwOEd7PliptUKaqudrlsnx5B+cRlYQUV5eK7s2cb6aH8bNV7dcfbDnNcOtasiAO2IVE3f1MtEOgVYnX11M3ECQVSnt3l1fv6AMA6FWTt3Cvf1tJ/VO7UZjsk6sapQVHFP9tl1ATNOh7XKeRCQhvfylq+9Q4wTvYsdD/wyS+IiaJJwtCV7i480o+wLKM2Oh5GGgblKyaMC1hc8cYupcvr0R1oHcfBlRaUjaqUKOIpaT9Y45UXHKuiG8Nh2hB07l3Eze6kwbWPiO/17P1qcf2VMfgNhnS0myPuldC4kXeyOSlRNH6v23bYhK8Wv7ssffdQs6LAT7Qz85jYuLq4kbB3h96q7xKwdGu2V+I591QaLJXUnkeMNEGNn0xQSI5+os1spy5yv6mlR/ZwC5/9kg8ClvAmjfdVqKaUhmAjVU5ZCja7u7md/v6k/2onvcw
 MKEnIt71
 W5fo72FgzhqIAwi31qgZGhS0AV/crnyXAaD8H2lS8kG9yrG/nRGz1bc9pM4hRbeSg10XwrE/2vT9qiGmZZBZqQUyC64ve4tg4F+3Ts6N3Cht3tv6n58OCjnqIFSxEKYW282HJc5gqYxjrMWFqDSxZnlY1qxror+SYosxGmtgvOq0dMIDD4UCMk6rZPsPbdaBe1w/SANNdSBHzR0VGLimRDsYyN7CB+dxW98rX9YuxMvDlok8QuwvASOsisjnA4kUuLZFmtSCJtGPtvo1p3AolaUJMCulKYTzDjK7RQ7qGN3q+A4EEkun8ykhGF8Ur1BnvCwcx0eEpVZd4ktz3hwXo5d8XTDlaLGmos8lwK7Ze0gSdIlcIog5h7kMzRNsnL5fpupzNSE1uFT6RB86IZbe2WWbA1L19c5aClcrW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>
Message-ID: <20250902051312.dvBeykOmh_qOf83TTitZOzrP8CDlthGLYwIn5OTUgs0@z>

Hi Jesse and Charlie,

On Fri, 22 Aug 2025 10:47:11 -0700, Jesse Taube <jesse@rivosinc.com> wrote:
> +static int arch_smp_setup_sbi_shmem(unsigned int cpu)
> +{
> +	union sbi_dbtr_shmem_entry *dbtr_shmem;
> +	unsigned long shmem_pa;
> +	struct sbiret ret;
> +	int rc;
> +
> +	dbtr_shmem = per_cpu_ptr(&sbi_dbtr_shmem, cpu);
> +	if (!dbtr_shmem) {
> +		pr_err("Invalid per-cpu shared memory for debug triggers\n");
> +		return -ENODEV;
> +	}
> +
> +	shmem_pa = virt_to_phys(dbtr_shmem);
> +
> +	ret = sbi_ecall(SBI_EXT_DBTR, SBI_EXT_DBTR_SETUP_SHMEM,
> +			SBI_SHMEM_LO(shmem_pa), SBI_SHMEM_HI(shmem_pa), 0, 0, 0, 0);
> +	if (ret.error) {
> +		pr_warn("%s: failed to setup shared memory. error: %ld\n", __func__, ret.error);
> +		return sbi_err_map_linux_errno(ret.error);
> +	}
> +
> +	pr_debug("CPU %d: HW Breakpoint shared memory registered.\n", cpu);
> +
> +	return rc;

rc is uninitialized.
You may remove the variable and just return 0 here.

> +}

Regards,
Qingfang

