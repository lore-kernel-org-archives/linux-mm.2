Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3178C8303F
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 05:20:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DEE26B0010; Fri, 29 Aug 2025 01:20:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08F5E6B0012; Fri, 29 Aug 2025 01:20:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC0C96B0022; Fri, 29 Aug 2025 01:20:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DAB4E6B0010
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 01:20:15 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8A3221A0572
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 05:20:15 +0000 (UTC)
X-FDA: 83828643990.23.D6ACC9C
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf25.hostedemail.com (Postfix) with ESMTP id A7B31A0007
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 05:20:13 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=p5lEVDPr;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf25.hostedemail.com: domain of viresh.kumar@linaro.org designates 209.85.210.178 as permitted sender) smtp.mailfrom=viresh.kumar@linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756444813; a=rsa-sha256;
	cv=none;
	b=2S3w+mQJQ+QNiXbZwu4CfP8V24W7T333GQRYFCtV4isIyZ/0fZKSUCDOro12KX7XtYOGpj
	bdfznuxs/toSTfKp7lINFncVD0pi9t7aB2bFiVXiv29bB2vsjDvvjOa2gZv4CCZY37JYIa
	5qWUi18Ct0xqWvNpvFrHg+hLANrpJZs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=p5lEVDPr;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf25.hostedemail.com: domain of viresh.kumar@linaro.org designates 209.85.210.178 as permitted sender) smtp.mailfrom=viresh.kumar@linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756444813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JvfbFYwUN2Wv0aTFajklPrgWujcFzYTBTym5k6QlzSg=;
	b=gPtv6nPdF+JzVF4p4gHWIQovCVQebbuM2+fBGIitXP4yZz2tWtKzQU+alRjN63WGrJKcdM
	2QVmIDPiKhS3R2oUxMK/PIV22CxWBEpctrBEktD6obcrM8JqAWrZK9d1E4e82eLRvEFgZW
	cMW/JKjZ8tN3+Uh0pxtkN44W+1WNsM8=
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-76e6cbb991aso1652166b3a.1
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 22:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756444812; x=1757049612; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JvfbFYwUN2Wv0aTFajklPrgWujcFzYTBTym5k6QlzSg=;
        b=p5lEVDPrEQGGwTwATXM7r3E4WFUSNS0E/LyjaDkFrKpftSqMaLSkQsyeH6cCk3prs2
         rLTLMRdK3i82OY9/oji7mN4fIKmjQyUHX8lx1kzMyGWVnn0iACGuzg6zgq+dC0hLGTdA
         3yGNUNE1T8PN0bET17cOp9kNDmV/rO1pgiu3R3HxA8qGCi/uc1aNegY1W8Y1dUAHRBdh
         KWJM5VA1kd9c9yBgaeff5vz7REwiiwdBmziL+tyZYZNPO27tv4h+CMgYzQ2RhGkpBVhA
         sm1ICFuM2GhQEo8ijQ45XP5u9Dil+O53i2tVeD3ytC9KTFrNfPP8mBV99tMnHUwJpSQ2
         vyNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756444812; x=1757049612;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JvfbFYwUN2Wv0aTFajklPrgWujcFzYTBTym5k6QlzSg=;
        b=m/+gyLZzHptPU8ETKvFjCBYKYOOOpdLcWesH5NF40ieNnTlcgH5R+RtY/amscHFaDL
         4orrEzNzkpnIJUEIhmk4Xu/JOInk2nC//LOULRYRiEz0P+ACrjdCmMnCm1Q+3Y0l2xIx
         IvlJ0BC5K8bZWl/iV7kfilxa0KT34aWYKZ8uvA8YMB+/X6p+m2OQ1x7TASS0mxOj8QrY
         UGXBjbuuJ8ii1Fha2VRvlKXjosKXlPT3eme0gIb+Xby8WvD6X7dGG1S44QnrY+APZfaa
         OusUydKbOnCyuKM/84F93rU3hETqVyd7zFWBDFEVHbp+0TQPBXwgExOLZ5WHVeeewJGB
         D4vw==
X-Forwarded-Encrypted: i=1; AJvYcCWXbj3cvXgKxoHgmnt79LNd/eBjp0dQLOrfSwSdHaS5BJgYE32GshIZANbFajvWbwKsL5xkRpl0Jg==@kvack.org
X-Gm-Message-State: AOJu0YwhssAGFiSjqhVOwjx2ifBz2ASuH4EuMFegwgrOZMwjSfHOS+AG
	9N+r+BpYcaCf/16k0PUg8cwyiN+t5//aJh9PCZSRj4bfHjUY/vNJjPnNoxHMRJ+xH94=
X-Gm-Gg: ASbGncvgTXQvqhdu9OA37YUWnukUlTkbWekb2rO+P9+axw1pT6VrvzCEU31nMF4a3yG
	bkvLIv3BMFkueTvDYtjdYAIHE92sdrKq8QGF5Ulps3GLTUlvSuPKyogEIbOtBanGRXcA8T417l/
	L2vwNL0nUHJzQvuPzkSLWSIcGUeSrkHM6s3bJfNjK1YEEf/uyu2V92M78APkGXKfnvw3Zn6ckw1
	t9uKEgFGD33/s7BapVoCe2drI1fVsLfuLWawe47trDhkPcOhN6Sk4Z1Aj4P8O7yze/XjSQESDyc
	KpkiWamZtsYiioSAuua4zqF1ADwGbTRyoUjVZR1Ao/iIKFcqs/X2ZT44fbO0dkcOdkTnT43qPAz
	VE/vltSexiGrosssNasvbT9BA9upzAEIxI20=
X-Google-Smtp-Source: AGHT+IF9rXnIKgqvJMpaMTUtFPVV7KQF3OFqGDqAWPTMUUDPlHpYvFwpf3iklNWoMxNux/mqBvASRw==
X-Received: by 2002:a05:6a20:7286:b0:243:ae10:2433 with SMTP id adf61e73a8af0-243ae1026c0mr8924481637.40.1756444812495;
        Thu, 28 Aug 2025 22:20:12 -0700 (PDT)
Received: from localhost ([122.172.87.165])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b4cd308f90dsm1046614a12.40.2025.08.28.22.20.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 22:20:11 -0700 (PDT)
Date: Fri, 29 Aug 2025 10:50:09 +0530
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Mitchell Levy <levymitchell0@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@linux.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Benno Lossin <lossin@kernel.org>, Yury Norov <yury.norov@gmail.com>,
	Tyler Hicks <code@tyhicks.com>, linux-kernel@vger.kernel.org,
	rust-for-linux@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 4/7] rust: cpumask: Add getters for globally defined
 cpumasks
Message-ID: <20250829052009.glitgqzv22zf7c4a@vireshk-i7>
References: <20250828-rust-percpu-v3-0-4dd92e1e7904@gmail.com>
 <20250828-rust-percpu-v3-4-4dd92e1e7904@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250828-rust-percpu-v3-4-4dd92e1e7904@gmail.com>
X-Rspamd-Queue-Id: A7B31A0007
X-Stat-Signature: mtdrzp151ykezt6kk5izoofm7pa43a18
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756444813-630491
X-HE-Meta: U2FsdGVkX19wMH3taDJVT8RP6uPe43clTlbtxqeXbOYftvENii5Q8iShcFa53th+/zJIv2F4PW0nXWuOcyq0L2YjcuQSwevRlGzPtIw9jbZRloG+WTqETb5w32OxfwkvWkE1Yl6UGW/7nVe7iF0AD3HiBABCgh8V2DVPP1hzC/c2Llobo/w9quokK2sHiCqek9pP405aExP8F3G9w1hrboSCAy4k5AOzvTdBl3gJ2bDghvCpy+fJyCrhd+HTs3iliCJOsMDyIxcsVrG0RZ6NkancbRKqVkNrO9U2BpdBlRobFHRXn7iQyg9YIf4f9LlV5HKhVNsKMOyyOMJzsrImym0A93lT7j7ppln56KA34VLKSLshq0OXT/jiDtlApxx3UtCaT/kcKKIvsEtyftuWvhCPeXfogC6Fwg+79O9R5IGjSGbslLNJOUyklt4OAdwhrcL1mA9A8dIb+ZpHeOoAi4ulFhfXHwEb3DRANCLqUO7v/+g1vL01dE2b31o58COJSZrOO5mSp0gP4ePSQpmkxkFqGpDj+Xl2rp0itt+emK3b4/AkzuaY0L7By1xXR2keulj6orbSsxJwKgqa2uSF15rtU3QF1NA0cSYVA7rx8g1LuTju10CsBsJVTIGpwQ3oJNYDkm/jAUU/OtXLE2Yt+1a43C9/LGFCiPFik83Kw5KbN0EGKvz9oiLOietAQ4OQ9MT0fGtQsxPpxTJrWKPTOMzg1HMB/153hi7maK0/8F/RrUE/fL3/mXXs6ljKzYp7jr3vfqvefeY7Fw55D/nGlzKD54RZWQW7P7qmE8sW6LfvalujdJvUO21oASk9enAwWW/2oeChCWdVRkxd1TvLVv81zRoBtXpthpo36643BPeRWM6lBYoR+WIWsH5OW0M8vCNH3qVe4+573l5a01wRNkGIV8T5KuAKONJ6jmTcHn6oA0+sj8Gk7+6EVCK1ZttDdPdLWJcJnPeQ9fanCUe
 qFSWL8Kr
 CB0t/kFmpQmcFx+W0/ZEKhQIOU6D8obq4WApSRSWrnDR5ym2/B0KIqLoTpGoGR467DmrJ7GwwaXPwEXNBV67MGLmkXCSdA5T/0UcqWCwxiVMiImeivQoESFKw22oN/OoSOkZVN2WVhG1+w99MsaZA4y0QdRxUruajTaHzDr9QkVLW6BioTvLWVSWONgKxz/x39U2GSoTZbGPBEd+Dy/ApZbFHC0EeA/fNovi6aftdkFNgqY2uZuNPc3y6btpgAcKquMZa374tPuM+MKWD9UdGwiMWTiFQG4+1t2UIjOKDj7rPChqEVTh5ee3N173KFIe7cQNAK+D2kHyWQsuOaN1erQjlBRyWhF3Vo3zG1kfkVKVb3VfxRFf28tuYe313e1sSSQMSokcwTzQ4JCeQVkFoFLpDMytYYJU/X35RORHGQC34figdtudYLhlk4qX8wdUJ1gn1ld7irB12CBqhy2VpR8vAtoNtwabBYxTbCQignhMKGk52fRo0aP+C5jR4DCtkqhDS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28-08-25, 12:00, Mitchell Levy wrote:
> Add getters for the global cpumasks documented in
> `include/linux/cpumask.h`, specifically:
> - cpu_possible_mask
> - cpu_online_mask
> - cpu_enabled_mask
> - cpu_present_mask
> - cpu_active_mask
> 
> Signed-off-by: Mitchell Levy <levymitchell0@gmail.com>
> ---
>  rust/kernel/cpumask.rs | 46 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 46 insertions(+)

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

-- 
viresh

