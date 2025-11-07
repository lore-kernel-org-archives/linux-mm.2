Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B9B8CCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 00:53:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 742788E000A; Thu,  6 Nov 2025 19:53:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7199B8E0002; Thu,  6 Nov 2025 19:53:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62FC98E000A; Thu,  6 Nov 2025 19:53:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4FECB8E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 19:53:28 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 019A61602FE
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 00:53:27 +0000 (UTC)
X-FDA: 84081987696.07.A760CD9
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf28.hostedemail.com (Postfix) with ESMTP id 196CDC000D
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 00:53:25 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JBApuLTf;
	spf=pass (imf28.hostedemail.com: domain of yury.norov@gmail.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=yury.norov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762476806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EMYmGSsqeU1KDtEF4CxFnVpHkfjLKjnXEKwE6nhE6B0=;
	b=YVsDZ7QN2ezc1SuzcE6DLi3qe6EVeOZHWbqVk+SzpCgXx/iItH09Wzobgutyow+jAvZ0eV
	3/qnB3BwEEMaXOPXyQxijnQpuEVOaLO51KUaxQpfbUZcIBOEVkHa28ZzpGPipRq7eSlSLV
	q3p+V6Nn5SzFtKuw4knwS7X6O1cQT8M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762476806; a=rsa-sha256;
	cv=none;
	b=lk3rgNiwKqV4SHjYWwXHJcUqnXn4gkAZr4YY0dKN+VsqhoQQRiDUOZqxG1BeLQmtTQaU+b
	LaHRGr8XOaTztk1IlymyP0K+cpvVSn6OQRKaREUvcEk+bmaRNYmd4QFNRjR6hKwbsYGNR1
	XWOdlHg4BG+O/z0lZCTUxQ1j7OqH1OY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JBApuLTf;
	spf=pass (imf28.hostedemail.com: domain of yury.norov@gmail.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=yury.norov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4ed72cc09ddso1253781cf.2
        for <linux-mm@kvack.org>; Thu, 06 Nov 2025 16:53:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762476805; x=1763081605; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EMYmGSsqeU1KDtEF4CxFnVpHkfjLKjnXEKwE6nhE6B0=;
        b=JBApuLTfzQYWVF+3P82xQOX5XcJkYqr/g+sAEO70pbJx34wA9XrTVuxLDVQKM8fk2l
         k61no0vL0ERvDQtVp09Ohy9xLu4vfzZbU0dTJ+g255siGEBVC7z1anAQTOFRP6WbVDeB
         ugEznEPkAhANWMikHTXz34La79kfUBZB25lJkBpL9cbK4xRLu1Bj5taAZWwzWkM+VlZt
         CvsK0wPZcUmQlROwFCB9FqySL+o2J7lhNsv7xGpIh95Xi1p10HsFcOyfCrMeqklVsxY5
         N/fD25vX4vWOgJjCZ5+CpLqhlriIETBEu7+hlD2p1flwnWYAYxe6d72cWhRq0wQya1LY
         d7hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762476805; x=1763081605;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EMYmGSsqeU1KDtEF4CxFnVpHkfjLKjnXEKwE6nhE6B0=;
        b=HETmfUeLx1dvoEqgdqyYUunJ0/IX8g5jeeAOH8DNsGe8uRySdqb743UE5v+Jp5r45I
         HN8HUyt26wMck8dcbZke45944vJUhCzetnfo9Y3RNE3vMfO99j9yyOEY1FR+lmo8+ZN1
         3jTcZKcnvKJWX32w8hh7M1D8YxjOUvXr1NMypW6KIMqbsb0mUQ2BNCGxAXvFfK2AOBp+
         fDy0WhsDnQdtWtoDC7YHf8JYCEGJd1Jb8Op7rHX0YBa99CYnMpKvQesj03DapTc3hDd5
         0rNWgO3GCTZfoHQc1023uGJfA//T2BSQtMXhie8v4fGfuGy/S4FTXZNCAZsuG+7n5A5O
         9brA==
X-Forwarded-Encrypted: i=1; AJvYcCUy+fxBQgzB5uny4H267BaqgrFzz5Wcs9OvDG19vhpZ+PmxmIhmyvERCSUQvWxh1ZLFie9vWXRiCg==@kvack.org
X-Gm-Message-State: AOJu0YzdZqw50TZww5/8+fUtKLo6g9as/DnNVmo7wi6DTTNcJZZsUGBM
	jhgg7ew9uSQVG5BJ4I8i2pTmI6i1Jx9jwWqtHDXYJu5iv2hqoZoPEGB6
X-Gm-Gg: ASbGncslwIgLyeuxLJpOUgv4VT9slDYHVKAwQ+t4EKuFrsXe4IVqVBIbRFd8gA2zJpv
	PtZejSupv6xRcwWWxrUxLYWCOliemRWdBGaBuJ4vb8I0pu1f4LI8Rn27XKdQR6hZFOX+eb1LKR5
	Zf/FsUl9SyQuPYDkSn6mK2KEZgRZRknJJ+47TW9ZX3LfGp8zwGfx2sYtrQnFpfZSd+kSgHjxy7+
	Lg/jWMuraMSmet2j0mTphpP8uPot+BQ4r8ViI9ar4/vw3PdO/PXntda5dGlpvFo61brItbbFAyT
	0a8HIGY7/v3c1Pm4jzvPy7AWe/Y5svYFgb81U43FA7RRUqZ2FPmEgW9LyK+xDUMXULiGjYpg/VP
	ih+MLt00FLIiRyz9i5GrWj5y83i2KB/j3pIXAcC8VruURyiAHGEZseRm6lFtiQR6p2SU/n7sCvd
	UdY62ZD5I=
X-Google-Smtp-Source: AGHT+IFiMc8RzsIBsIzMJ+XwkCfeVR2K1y5iqPGYwD/UYhIHGqwy9VQsEjUeh10FWOEZ8H4o0TionA==
X-Received: by 2002:ac8:5783:0:b0:4ec:efbf:4ef2 with SMTP id d75a77b69052e-4ed94a6a15fmr19280081cf.47.1762476805099;
        Thu, 06 Nov 2025 16:53:25 -0800 (PST)
Received: from localhost ([12.22.141.131])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-880828c5816sm30074976d6.4.2025.11.06.16.53.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 16:53:24 -0800 (PST)
Date: Thu, 6 Nov 2025 19:53:22 -0500
From: Yury Norov <yury.norov@gmail.com>
To: Mitchell Levy <levymitchell0@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@linux.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Benno Lossin <lossin@kernel.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Tyler Hicks <code@tyhicks.com>,
	Allen Pais <apais@linux.microsoft.com>,
	linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v4 2/9] rust: cpumask: Add getters for globally defined
 cpumasks
Message-ID: <aQ1DAn7Djc19CgGF@yury>
References: <20251105-rust-percpu-v4-0-984b1470adcb@gmail.com>
 <20251105-rust-percpu-v4-2-984b1470adcb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251105-rust-percpu-v4-2-984b1470adcb@gmail.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 196CDC000D
X-Stat-Signature: 5w3diq9icdbj4t3o6yzs35ay6i61ds4c
X-Rspam-User: 
X-HE-Tag: 1762476805-804511
X-HE-Meta: U2FsdGVkX1+pWAYqREil3gWrp01IKEF/craf9h6kQJmMTVsLgNKbLAC6CsLK2J1fijmFVzXXXGnNUO8He7f2vfxf1Qo4uj2EBBp97FAvlTczasq7CZUAJy9np0xG5KRkzmK+UKDNAQpNq2eTdwqYa3/+Ubj73eIyy1ihreN5hZory9XkNeRYr73ZzDVMug0vp1kObvJ/mDq99q4mXYCbp9gkMtOxhQC1s8k+vDGEQyLWP+jxjeP93bW8u783G9oT78F4vo6HtYiMZELr/WFQUbll74it8StOnFc16hUI3NvnrUTxOB6Hj9vhWFxUtfr2mO0RTltudPOoNw1p+ozanduGG1i1uvOQB+VMVHyXpKKOf4PvQtyqE0Wf/M22vNJXlCoCszyR+DbpowFW/8PIYuCn58cLGQh+sdUVPKEq5bTi8ip1ALcxvB6/F3F9nqPJXqV32bncnkRfhJWO2lWReHH2dhfj02xRZZ9Sr6l9J4wiqCD3ubnDcdvbWvPs80p6WzJf7z2cJ5ncW2tcAaah91TmwEoK2mtYGRqNiODrdXtF5XSsMAUgdQn2bTpIJR+oZ1gezsghCcRX3zOGqDm8SaWkhd79JDkZ1VCXCevUU5RlHont4icBj34SxGFzm9oMMimdCAzyeZkn6qjn5wV5gCyKhWeC2OThCH2j8GJNvWMA4GJ1Sr6ZahH9tf4pm+HKNIuu0LNepbZScxVcTUjOvN9AYyvPyRpFsYPpwAIF16Fg6XKIfCyI8HRUHxcZ4suywQAfQVR/Pqq8L2FJO5WTk4J8ehCSA6cxEQoSiSW/ixzL2Wv4dBBpKMK+3fCfZaO9D0KWNg8f3GheGFAHHEu7qnOYfQ+JWQu8BqJmvt7hEkLjtuNa9nYCiAGwxfRTiJroKP9+cmtOct3InyIxNwj9XeC4vFbR/M7isdDGU5yX5rrsTA0dstrFb+SsOuThxknavvaIg+b93GDx988XMbP
 nLOFEEWg
 Fv/dAbeWJFper9A0gg36q/tj4VFyUS4UxdanBTp1Z4G0A5w5XWAJ22umbETeoAuiOjH4SVWt7HNrU14zRjSDc1Mpd861KicFV32B237u/HXmdG/B5/QW6jbK1dttAaqSBDhKTbkBVLg3sEPHFbYQ4etjBjKdqYo8qDVe4wXglW9ZTzMujW4aocAPHJSxG487NPMsDeIhqMsazT2SYvJjWCprnCCU9Tobayr8bdwL+iWoMON26e9AfYzRxENP6dAM+jar9QvFeZAM8ulVxXAUGlGaKKxKYXUJzwdQaydBSlLuyq4allGFvXJhFqYt2JTcuJEbggJ1IU7iZe/rieHgvvqGtTDgj0E884S7xuA+t8dy4Ww2LqgEVjohV7c/I9YAWh9XqYpIGDWrLYEc15D4/LXhaKtEirxvonL/YGgLRq6Nm17ohOniuC5SoGRJbtllTHjDlGXp2WmnOyZ8+VbUhLApqtS50FAn8kKeDqz1tadxMkUCdhFf2pCigGxSvfVAID7SfjqB4xcAO0cbH3eMS7hA1g+Yg14gPBAA0+4P1ahxIFAkdU5jsgiFNiJf15aM0rmdRVEJk/9I1s8zwCqq5mqR0tUIUVlzSoHvYQw1bnGbiiWJt05JmlsiHNFD++5st6rpEIrSMS//5QJCP/OWSMjqOqxUDmypN1lKB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 05, 2025 at 03:01:14PM -0800, Mitchell Levy wrote:
> Add getters for the global cpumasks documented in
> `include/linux/cpumask.h`, specifically:
> - cpu_possible_mask
> - cpu_online_mask
> - cpu_enabled_mask
> - cpu_present_mask
> - cpu_active_mask
> 
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> Suggested-by: Yury Norov <yury.norov@gmail.com>
> Signed-off-by: Mitchell Levy <levymitchell0@gmail.com>
> ---
>  rust/kernel/cpumask.rs | 46 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 46 insertions(+)
> 
> diff --git a/rust/kernel/cpumask.rs b/rust/kernel/cpumask.rs
> index b7401848f59e..a6a130092fcb 100644
> --- a/rust/kernel/cpumask.rs
> +++ b/rust/kernel/cpumask.rs
> @@ -77,6 +77,52 @@ pub unsafe fn as_ref<'a>(ptr: *const bindings::cpumask) -> &'a Self {
>          unsafe { &*ptr.cast() }
>      }
>  
> +    /// Get a CPU mask representing possible CPUs; has bit `cpu` set iff cpu is populatable
> +    #[inline]
> +    pub fn possible_cpus() -> &'static Self {
> +        // SAFETY: `__cpu_possible_mask` is a valid global provided by the kernel that lives
> +        // forever.
> +        unsafe { Cpumask::as_ref(&raw const bindings::__cpu_possible_mask) }
> +    }

Not sure about this '&raw const' syntax, but I want to make sure that
all this getters provide non-modifiable references. To modify any of
those masks, one has to call a dedicated helper like set_cpu_possible().

Can you maybe explicitly mention it in the comments?

With that,

Acked-by: Yury Norov (NVIDIA) <yury.norov@gmail.com>

> +    /// Get a CPU mask representing online CPUs; has bit `cpu` set iff cpu available to the
> +    /// scheduler
> +    #[inline]
> +    pub fn online_cpus() -> &'static Self {
> +        // SAFETY: `__cpu_online_mask` is a valid global provided by the kernel that lives forever.
> +        // Since we wrap the returned pointer in an `Opaque`, it's ok that `__cpu_online_mask`
> +        // may change its value.
> +        unsafe { Cpumask::as_ref(&raw const bindings::__cpu_online_mask) }
> +    }
> +
> +    /// Get a CPU mask representing enabled CPUs; has bit `cpu` set iff cpu can be brought online
> +    #[inline]
> +    pub fn enabled_cpus() -> &'static Self {
> +        // SAFETY: `__cpu_enabled_mask` is a valid global provided by the kernel that lives forever.
> +        // Since we wrap the returned pointer in an `Opaque`, it's ok that `__cpu_enabled_mask`
> +        // may change its value.
> +        unsafe { Cpumask::as_ref(&raw const bindings::__cpu_enabled_mask) }
> +    }
> +
> +    /// Get a CPU mask representing present CPUs; has bit `cpu` set iff cpu is populated
> +    #[inline]
> +    pub fn present_cpus() -> &'static Self {
> +        // SAFETY: `__cpu_present_mask` is a valid global provided by the kernel that lives
> +        // forever. Since we wrap the returned pointer in an `Opaque`, it's ok that
> +        // `__cpu_present_mask` may change its value.
> +        unsafe { Cpumask::as_ref(&raw const bindings::__cpu_present_mask) }
> +    }
> +
> +    /// Get a CPU mask representing active CPUs; has bit `cpu` set iff cpu is available to
> +    /// migration.
> +    #[inline]
> +    pub fn active_cpus() -> &'static Self {
> +        // SAFETY: `__cpu_active_mask` is a valid global provided by the kernel that lives forever.
> +        // Since we wrap the returned pointer in an `Opaque`, it's ok that `__cpu_active_mask`
> +        // may change its value.
> +        unsafe { Cpumask::as_ref(&raw const bindings::__cpu_active_mask) }
> +    }
> +
>      /// Obtain the raw `struct cpumask` pointer.
>      pub fn as_raw(&self) -> *mut bindings::cpumask {
>          let this: *const Self = self;
> 
> -- 
> 2.34.1

