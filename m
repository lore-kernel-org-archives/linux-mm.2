Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBF34CE8D6B
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 00:06:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1163B8E0011; Mon, 17 Nov 2025 19:06:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C6798E0002; Mon, 17 Nov 2025 19:06:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED0A28E0011; Mon, 17 Nov 2025 19:06:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D7E948E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 19:06:37 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7BA18B7B33
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 00:06:37 +0000 (UTC)
X-FDA: 84121786434.10.2FAA22B
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8E8328001B
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 00:06:35 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=QvLRgSIR;
	spf=pass (imf02.hostedemail.com: domain of dmatlack@google.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763424395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1v4fRZdVLhKe/ktZvpTDlH6fFhc+2rF0aLfRAFXmPdc=;
	b=k2ooHAsNZ/UXZHp5A88RYXBqWJe6LXKFUdLeFYxkA5Eb44s8k73biyN9Llha40r3lx53Nx
	XSqAPXPLfCllBUCMmadZLzosrEb5+JXjEoJzRdA/ZfzceV1Y+gtRe8uVUXSMpZq5D7wc6o
	Ggg1gh/Z7LA804ar7rcxpuVCo4JaFnA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763424395; a=rsa-sha256;
	cv=none;
	b=JJ2Z57ikJwa7jcF4sUXbxnHHSdMvuCN12B2a4dl+mmVeSWblzFP4Q157RNS7H4cdN2hrci
	SJBMB7TPdaMBghhfnec/Qf1nnUqMhNEHJNfPqaWdQ9D9AermVUYTHMq7Teo3YeZwxmGVqF
	leCg5Ml7sICYyrtNfFJ3qbbfk2wnecU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=QvLRgSIR;
	spf=pass (imf02.hostedemail.com: domain of dmatlack@google.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7aad4823079so4436316b3a.0
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 16:06:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763424394; x=1764029194; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1v4fRZdVLhKe/ktZvpTDlH6fFhc+2rF0aLfRAFXmPdc=;
        b=QvLRgSIRQKw6MvBx5e91DhbEKl5YyfRdezYAHnGzZwTSp3GF40HVqqpJfrPhzoZaOY
         UF0OMy+tmg6HFFzBrCCem9gq4kwsMA+LSO82JS7MHxEo1njVHpm+JUiaPrJWuE1gLSgw
         EcU1k2Da0rjR9g/96y9Pt3YV5CICRwlEmTfmEQ979a2wIbASo5uLi8h90ZYB9tMfjqhe
         pvG7LVT2E88YT86HAb1rdkUah32j1ao2fnmD1FbpCFHb8cg1TBfiehDmKhxb2UpMj98E
         W073df14bLUJA5Xj3MjMkZhTZmJZ0u+6mkflqHURHgX1NoLrNIiu1xL3CyPluRgdAeni
         xXRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763424394; x=1764029194;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1v4fRZdVLhKe/ktZvpTDlH6fFhc+2rF0aLfRAFXmPdc=;
        b=jkuHLsjbcLRclSfYRLqOF/0rvht6SWDVK36p5nJ8d5ERWEl0GUPFS0MHRcYfeTSoZT
         c9ru9vLAEsMrcm9JmymIDyQEoK2l7Ds9EI+QoKDRSzZhZ4nB9QUqQvaSnCdF23O2mAjx
         /evCqn8hlPDlY5HT26H8NGZuaI9gDRHRowDDix2IPAZdlTux7i1QHg8dPQaJ6qAxELLe
         LPCKeQmkkMSOJ9fH1kWpRtTpezbrMvW2aaJ1kB/UwbG3ngTew5wQS97i9aWwzzoSSw6j
         eSyN4n6Zy4VfeFyfHQQwLSZqT8qB4hjflOiTnJcYloesHz9a6u57vwwLnBQj+x+wq0GD
         l8GA==
X-Forwarded-Encrypted: i=1; AJvYcCURxBamKkdorteN1BkutWqMMXnRVgUsFP6Bz0EE1hi3eF6ajxvvBXf4UDjurICLy8aLC5FPS1e3hA==@kvack.org
X-Gm-Message-State: AOJu0YxxBSTQez8PJF67lxp5Pym9f6qoP73bmi/py9Etr+u2lS62zyXh
	buPAuH7SWCJ0/eRVy96q1oF8vbH/9OVhH8EQ5paR+zzkvyVlz7M9g5RtDXO2wxN2Ng==
X-Gm-Gg: ASbGnct7W/aDxdUnns0oEE31kCOjwkDsTvNsFazLZmV4QtRSZNcvtn0+hWqXnRW9wv/
	PmMahitQNcdlD/UFnO4Q7wen4+Kz0dzot31iYUIpxQOcq+2Yhmhn9dRtoIvLVwFCSLQtz2r6ewz
	bZIM9I9kZdvjHhfB/huH7VCzYelqlX+ZvqgnfZUd2RsCN9wnwNsKu53H38vDjTak1+n7IdfJ8Kx
	k12Nbh9FZAAUvRqa2sjjry2C6vqkBGh7LWJhsOIGDHMGSwtT8G19VBPIOYOcrG1LH1S6f0/L8eH
	JEwdW7vfUOPRCjVDqL276J+8FsNcBEWszxCke0Y3mxtowg5V+q4FCRWDmDupGG07PQqg0aitGP/
	RnPZaUs2QYpIKoSthv0EwtvWXjEvQNKvr0GEtS+xDFQz2kpBLg8bYh7Bkdl/KtjgJN27DFCGHNG
	J+19N7KAS9PLMEVNS0XGfUXw42SSzuIsZDm8/EtV7TJyr8iUwYP7Ibjatyrw/xIa4=
X-Google-Smtp-Source: AGHT+IHkJBvRbGUG30Kr3T5gR1UjB+qV085NIT1CUVV/7jNIJcaOzKed5XoscCfn8280NZXc0GRAQQ==
X-Received: by 2002:a05:6a00:2d1e:b0:7b8:c7f7:645e with SMTP id d2e1a72fcca58-7ba3c07eeebmr19714686b3a.17.1763424393959;
        Mon, 17 Nov 2025 16:06:33 -0800 (PST)
Received: from google.com (132.200.185.35.bc.googleusercontent.com. [35.185.200.132])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b924be37fbsm14602912b3a.1.2025.11.17.16.06.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Nov 2025 16:06:33 -0800 (PST)
Date: Tue, 18 Nov 2025 00:06:28 +0000
From: David Matlack <dmatlack@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com,
	rppt@kernel.org, rientjes@google.com, corbet@lwn.net,
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com, ojeda@kernel.org, aliceryhl@google.com,
	masahiroy@kernel.org, akpm@linux-foundation.org, tj@kernel.org,
	yoann.congal@smile.fr, mmaurer@google.com, roman.gushchin@linux.dev,
	chenridong@huawei.com, axboe@kernel.dk, mark.rutland@arm.com,
	jannh@google.com, vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, linux@weissschuh.net,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-mm@kvack.org, gregkh@linuxfoundation.org, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com,
	myungjoo.ham@samsung.com, yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com, ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com,
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com,
	skhawaja@google.com, chrisl@kernel.org
Subject: Re: [PATCH v6 18/20] selftests/liveupdate: Add kexec-based selftest
 for session lifecycle
Message-ID: <aRu4hBPz2g-cealt@google.com>
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
 <20251115233409.768044-19-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251115233409.768044-19-pasha.tatashin@soleen.com>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 8E8328001B
X-Stat-Signature: 664g9syxgfr4sdsxz7tn7dpheywujsrt
X-HE-Tag: 1763424395-397226
X-HE-Meta: U2FsdGVkX19wMGtms7Fa20MnW5bWGlhGzpMEdJ3GLezybze4x27Him2zoK47hY0HW/z1BslE1EXyBHTFxJ64m72PJXqZoaAD48NzivtKFDMFfgfC7N3b4NMiRtOTPz3QeLJgOfutt/UpBilqsaE7nvaWQOksg1oMyLE3QlLUldl1SRMWGbcJbCPqgL9ONhCQrjyA4PMnGZIptBn5AeDHW13RlqCgNz+wEw63Kdyo3Gde+ploiUXomCvcFR681Ds8gyfD1D+fisx65NTuuP4Ei2MGol8Gc6rfXC9Wbi163pwazTbpfTFbMNZEOQkH9LPX9FIsJCpHYWg0jdAAQ7CjwlDtUaCSYoyfm2WlVohSp9SCTyvAThcZqTPy/DMCLJE7w+dS5RHWEjpoa34tA+OUwGTOLqIk7y5AQXe1xG2MA7I7dz12g0/g3oka0BtJOrW4wd0cxV6+wva+iSHTW1g7Gkc4umUtTk1R/4TyiD6A6WfZO+sFY7pQdybfK9gOh9JhCCGUU38HjGC3x6MjCn0YuaGYalNqZ6c95LdI8iM9i8mKu9D/HxqljQ64/8wJcSVHGjxt5n0OS8QZeyxx5XklDaZ1i69e6SIF1cJnv8FXppWhmVTP0VVhOHuyh5Uh2m+iWTKuSqf/GskfCWKqutNRdIU84MFRFIgIwhq/NhoG6vUjrsAKAZCSsW80sr0x4b+p4JpuvrX8dJhrsl05wvRPsfU2QU9HjcK8t+cjzQq3QJUARDq254iqs38b42VhaKWRwE2WkFwL3CCHXRoqa/9AS5ufZpR3UYXGgJ8Rsq09gavL8805WqwxOy2Tbd9jXjVQyg3Bp6iC6XwLwbx6dyywe0NoExDANG19G2344vBB+FQYt3E1lqX347MKofr+w7L6PQqUvANltEG9VYIKiT+r/GLNGvtC9z/FCzyN1U/3qsyICtRxHWerw4y6DjfLiihA+iq3xhRxTy9ELcVQaPc
 Wy7Dpb1/
 yVNzQxnNNJFJ01lpT8ClqM7kbwE3VXiypGJjThurnvcxM3bBVmvTamiCqQj84QDRNtNxZuxJ0Wurn+fjvV/Ot1anp3fOY80ELfGgBs5kb9AilN3EVpqOzySWkSIoaIFOVSMGQNkbJIYlyWT7fZvQ7SMqLyb54drmKobOYEqCzFTF9mmdrYCrkp+UuKTkcODpnIZtcdp0RUioDCEA3HQ9oNg4QzJmK4i+/M9e+4Ojfy4OKxnwVTrCq2HIw1fGWT4+j88ihe43DPvq6BCwarBpaaH24wozEBEQaGKTDCLLIkFrARqNpggXEgcZg1CYj3PW2OMe6iN/pSSLN9Xsk16/V3Dbih3klcvTtK3GUFwumqRLfWQCMbv6DvVsQ38CW8nKTvr2kVoeh6QDTq8lLeVqY1jmcq+hu1ViyQWsFgFvAKP/4eVTtqqIE6bNFhQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-11-15 06:34 PM, Pasha Tatashin wrote:

> +/* Stage 1: Executed before the kexec reboot. */
> +static void run_stage_1(int luo_fd)
> +{
> +	int session_fd;
> +
> +	ksft_print_msg("[STAGE 1] Starting pre-kexec setup...\n");
> +
> +	ksft_print_msg("[STAGE 1] Creating state file for next stage (2)...\n");
> +	create_state_file(luo_fd, STATE_SESSION_NAME, STATE_MEMFD_TOKEN, 2);
> +
> +	ksft_print_msg("[STAGE 1] Creating session '%s' and preserving memfd...\n",
> +		       TEST_SESSION_NAME);
> +	session_fd = luo_create_session(luo_fd, TEST_SESSION_NAME);
> +	if (session_fd < 0)
> +		fail_exit("luo_create_session for '%s'", TEST_SESSION_NAME);
> +
> +	if (create_and_preserve_memfd(session_fd, TEST_MEMFD_TOKEN,
> +				      TEST_MEMFD_DATA) < 0) {
> +		fail_exit("create_and_preserve_memfd for token %#x",
> +			  TEST_MEMFD_TOKEN);
> +	}
> +
> +	ksft_print_msg("[STAGE 1] Executing kexec...\n");
> +	if (system(KEXEC_SCRIPT) != 0)
> +		fail_exit("kexec script failed");
> +	exit(EXIT_FAILURE);

Can we separate the kexec from the test and allow the user/automation to
trigger it however is appropriate for their system? The current
do_kexec.sh script does not do any sort of graceful shutdown, and I bet
everyone will have different ways of initiating kexec on their systems.

For example, something like this (but sleeping in the child instead of
busy waiting):

diff --git a/tools/testing/selftests/liveupdate/luo_kexec_simple.c b/tools/testing/selftests/liveupdate/luo_kexec_simple.c
index 67ab6ebf9eec..513693bfb77b 100644
--- a/tools/testing/selftests/liveupdate/luo_kexec_simple.c
+++ b/tools/testing/selftests/liveupdate/luo_kexec_simple.c
@@ -24,6 +24,7 @@
 static void run_stage_1(int luo_fd)
 {
 	int session_fd;
+	int ret;
 
 	ksft_print_msg("[STAGE 1] Starting pre-kexec setup...\n");
 
@@ -42,10 +43,17 @@ static void run_stage_1(int luo_fd)
 			  TEST_MEMFD_TOKEN);
 	}
 
-	ksft_print_msg("[STAGE 1] Executing kexec...\n");
-	if (system(KEXEC_SCRIPT) != 0)
-		fail_exit("kexec script failed");
-	exit(EXIT_FAILURE);
+	ksft_print_msg("[STAGE 1] Forking child process to hold session open\n");
+	ret = fork();
+	if (ret < 0)
+		fail_exit("fork() failed");
+	if (!ret)
+		for (;;) {}
+
+	ksft_print_msg("[STAGE 1] Child Process: %d\n", ret);
+	ksft_print_msg("[STAGE 1] Complete!\n");
+	ksft_print_msg("[STAGE 1] Execute kexec to continue\n");
+	exit(0);
 }
 
 /* Stage 2: Executed after the kexec reboot. */

> +int main(int argc, char *argv[])
> +{
> +	int luo_fd;
> +	int state_session_fd;
> +
> +	luo_fd = luo_open_device();
> +	if (luo_fd < 0)
> +		ksft_exit_skip("Failed to open %s. Is the luo module loaded?\n",
> +			       LUO_DEVICE);
> +
> +	/*
> +	 * Determine the stage by attempting to retrieve the state session.
> +	 * If it doesn't exist (ENOENT), we are in Stage 1 (pre-kexec).
> +	 */
> +	state_session_fd = luo_retrieve_session(luo_fd, STATE_SESSION_NAME);

I don't think the test should try to infer the stage from the state of
the system. If a user runs this test, then does the kexec, then runs
this test again and the session can't be retrieved, that should be a
test failure (not just run stage 1 again).

I think it'd be better to require the user to pass in what stage of the
test should be run when invoking the test. e.g.

 $ ./luo_kexec_simple stage_2

