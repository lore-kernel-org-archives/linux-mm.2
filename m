Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42231E6BF33
	for <linux-mm@archiver.kernel.org>; Sat, 31 Jan 2026 01:12:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81B776B0088; Fri, 30 Jan 2026 20:12:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C88D6B0089; Fri, 30 Jan 2026 20:12:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D4F16B008A; Fri, 30 Jan 2026 20:12:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 59FA56B0088
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 20:12:02 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D648F160859
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 01:12:01 +0000 (UTC)
X-FDA: 84390482442.08.12FA963
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf16.hostedemail.com (Postfix) with ESMTP id E84A1180002
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 01:11:59 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=VEQEGAhH;
	spf=pass (imf16.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.52 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769821920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EPpl6A64UKlYlKR2j1fRkib4LdNnz2WqgktVIjm2uzU=;
	b=S3PMV8w9vs0kPlKheQv35YTW+QXJAmYGJ+5ABFGgM9mlBxys9CxOvP4hjx5LIbVV54NDeg
	hu43Qjqw/m1Vnj/yp4D6wYiGPTq0KCJkK3TUb3qfSQWwuFzFKPuvRDMjToHX+lbY0Pzicg
	ghPttzCiAjJWfQdvrd08/jqZivfzUmI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=VEQEGAhH;
	spf=pass (imf16.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.52 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769821920; a=rsa-sha256;
	cv=none;
	b=nMN7Zfu7aT8s4NCWKXtKuRmDay5QfiF8A2zsYpQH9H6E6Xbwvf2Q64FhAY+t3CXReB2EOz
	ZqKSV6qn5V5HQfsdx7juBM4q+RXoBTTxK7TrSrVSadYKLUPGPbHYHnvXzO4gKE9rSmlQ75
	cbzbd2Z6aUK6HO1R2UHCptNdpOiBfes=
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b88593aa4dcso389401766b.3
        for <linux-mm@kvack.org>; Fri, 30 Jan 2026 17:11:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1769821918; x=1770426718; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=EPpl6A64UKlYlKR2j1fRkib4LdNnz2WqgktVIjm2uzU=;
        b=VEQEGAhHsajGsCBoP+oapB98hXBSI6CU7iOiYcg6wyekNRMD+gM262m+iR8Orvwf4q
         w3gNAY9gsqVbSZCN0tlUbi+xKahgMvopcXl7rAnmMqE1e+h5DnjRsDxQ4dYlkbLBSume
         RooJ2RjLk8eqVvqH6Jadgh24A17Zwq/2hXeZk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769821918; x=1770426718;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EPpl6A64UKlYlKR2j1fRkib4LdNnz2WqgktVIjm2uzU=;
        b=iqMHTSoyXPW6lE2R0L7jEYBaOVkX5EK4f7OfASORwFV/2y8uiOSUyU0mhr0YY+YX5h
         BSWLrPaBSGgGt56yV+le+W40HzTQK+vZi3RoQ5AUiBRqYzr0DR4fwZFh2B2Dle7fmiel
         aKHQjSHGnSyCVSkSeqdR5YbWdal2Vq6n7eCsfOkabyhU6rvfaNT7Ye0WDP9hDNzjYiN+
         pBEAk2vyVc2ZrwFRvu9G6WuTkQuDxLV4vO3YkCDI6yTSPLZFMpEH1rFPL+uzHqnXWdPH
         RsjsYA9McjIPlsvP8dQwG+sdPjSt0CJxuAVoNo2W8kmZswBph8KaS7N8bYQyJ3geRiVO
         6HRA==
X-Forwarded-Encrypted: i=1; AJvYcCWRpjiyL8rDQn/n7pVx6MOGxSr3cYA5ZcKwlY5tnMp26vnsVELeyF9lmhSXJ2wWzT+jQ/x/AqmyFQ==@kvack.org
X-Gm-Message-State: AOJu0YzYSsTSvVnWOp/N+eGRmQv+u84/0ykK7ZUckptcw9Zm1FbGIlMX
	vfJHz9cKsWHIvVyI0mW8k1A2aNC3sFWRbpqZQBA/Q9YYlFqjI8Rc/YTF7ZusuXseS+OfP5V8diW
	ePsDySM4=
X-Gm-Gg: AZuq6aJLkauIYnAtF90MBkJIDhjBHVFWwd+ngkDCpu6GGhBwj4x/83YCZ3vQfEE2LEr
	YJWfob7eE/MGTHFtDl6ND90jrOrgmcfN01AkloXZe75QNtov+Jd9CFEbBHTX8gUUrFy+LgsqClw
	qFCWQ2ixckSp80kA74lv6v9KAYS0C3PgFS2nfZbzxfJUdZyfXRxNQ5JRXlAF4tXa0wpMSLG5e2C
	rsJBjIYdq3CKp/96wP6VlN3AnfLrzR8h2wgManEp6x4jkSsnITY17xQ9+xVxjmUF0onNNvz3Y0p
	5TF+D0b00qi/FrmcIni4/yYslAFzoAXI+/ReNOJycf+fyYgjt0j/31oLzPWIDdu95uOHWCWZ7uq
	n9GqRXFl1sqp/fbbZK3XxZ+Cbi9HddRxd32XkXVXwMz1cGvVnBXTt5EvX4cgP0vuJklnc5wGejp
	zdSls5U7PI8AoefDgxX6KRjFDz5OaW0I/8QUf1yTTtjQlx/2JrQe3ba7TjvUjC
X-Received: by 2002:a17:907:709:b0:b73:8d2e:2d38 with SMTP id a640c23a62f3a-b8dff797237mr298043166b.50.1769821918283;
        Fri, 30 Jan 2026 17:11:58 -0800 (PST)
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com. [209.85.208.51])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8dbefc667asm507728766b.22.2026.01.30.17.11.56
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Jan 2026 17:11:57 -0800 (PST)
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-65808bb859cso4124179a12.2
        for <linux-mm@kvack.org>; Fri, 30 Jan 2026 17:11:56 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUjSRW4zm8p3jRuREenjF2LKm63oO9MX3qXfgKb136yG8IsRa+8kSFpkPFwo1YWct6+4VV4NBPvLA==@kvack.org
X-Received: by 2002:a05:6402:35c7:b0:658:ba49:96c2 with SMTP id
 4fb4d7f45d1cf-658de54e61dmr2863591a12.6.1769821915767; Fri, 30 Jan 2026
 17:11:55 -0800 (PST)
MIME-Version: 1.0
References: <CAG2Kctoo=xiVdhRZnLaoePuu2cuQXMCdj2q6L-iTnb8K1RMHkw@mail.gmail.com>
 <20260128045954.GS3183987@ZenIV> <CAG2KctqWy-gnB4o6FAv3kv6+P2YwqeWMBu7bmHZ=Acq+4vVZ3g@mail.gmail.com>
 <20260129032335.GT3183987@ZenIV> <20260129225433.GU3183987@ZenIV>
 <CAG2KctoNjktJTQqBb7nGeazXe=ncpwjsc+Lm+JotcpaO3Sf9gw@mail.gmail.com>
 <20260130070424.GV3183987@ZenIV> <CAG2Kctoqja9R1bBzdEAV15_yt=sBGkcub6C2nGE6VHMJh13=FQ@mail.gmail.com>
 <20260130235743.GW3183987@ZenIV> <CAHk-=wgk7MRBj4iwQLHocVCa94Jf0cMEz2HzUAS9+6rGtnp4JA@mail.gmail.com>
 <20260131010821.GY3183987@ZenIV>
In-Reply-To: <20260131010821.GY3183987@ZenIV>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 30 Jan 2026 17:11:39 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiXq-bPyKywNOw7z6ehrVReyS-hSPuQkJvuhJWfXGFm=A@mail.gmail.com>
X-Gm-Features: AZwV_QiG_nByRrd83VYAdhaCU5_carsYUlImGLyJR9w-28CTqo3phlyWLRwFL8I
Message-ID: <CAHk-=wiXq-bPyKywNOw7z6ehrVReyS-hSPuQkJvuhJWfXGFm=A@mail.gmail.com>
Subject: Re: [PATCH v4 00/54] tree-in-dcache stuff
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Samuel Wu <wusamuel@google.com>, Greg KH <gregkh@linuxfoundation.org>, 
	linux-fsdevel@vger.kernel.org, brauner@kernel.org, jack@suse.cz, 
	raven@themaw.net, miklos@szeredi.hu, neil@brown.name, a.hindborg@kernel.org, 
	linux-mm@kvack.org, linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev, 
	kees@kernel.org, rostedt@goodmis.org, linux-usb@vger.kernel.org, 
	paul@paul-moore.com, casey@schaufler-ca.com, linuxppc-dev@lists.ozlabs.org, 
	john.johansen@canonical.com, selinux@vger.kernel.org, 
	borntraeger@linux.ibm.com, bpf@vger.kernel.org, clm@meta.com, 
	android-kernel-team <android-kernel-team@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E84A1180002
X-Stat-Signature: zn7bz4xa456ntqoztuuoziytrkuyt598
X-Rspam-User: 
X-HE-Tag: 1769821919-405636
X-HE-Meta: U2FsdGVkX1/7sZswNNKIwsOZiMquwEC+b0adMruck3tgx3QvcVmTyVfkTl3GHBa9c11VgR80LLrclNX2Vs6i1J7HtNAgVu5wISO/fBG1gQMb8FVQBxz+X1T9Pihovkm3IsX4CSNdaVdERO1/NDClOudd89x6Vmm/Yza4iLeXwkCMP8KplXIGThoWevGVvkdUM9oMr6MdAMpVY03xj/UAXOfJ9faEDGh6Vs1aoC3f3WUoV8z6cV2FlGCsdLlSkAg0K5LxDc2zxN8KQSyvvSr79c3AeTeg/j6+HQlqxHHcM5UELWD79rLBDWXzyg6g1b2B1LbIZk3+idst+Quy6pW+nqXjTnFiQIqaE8cGc0MffMWZn7dAlcIRxsksjXcGKXML+GYxVxBO09YEV++itkR5ddccd+tarzvHBbw2W4CR7WOQUF0dEjW5HiWhOZdI1n6GFy/MfCCza4kKga8OAB9zdv/QYYrZyx9nsUeRM0uCOuMNxSUdFJNyAcyQ1DMbAJproXgnL5dlLHwboSDztvjNQbA8mStaDpfJgjvvm09ChwG3odP9sSJWGMno9lIJpUQRoFL1dQy00UMF1yII0JPlVmzhIxlpAu+bQjjRQB3+O1V15TgHJxzvf9qCPQU+hq278t2+8BpXW7O2Uu9yqqyBNjvji9ck7g8/B3mcFagnFk8HIx+EG2mEw/1OwE/pQRXIH1I7hnFMOVcsC3xO+uRmKt6qfi1gx9mT9dneH7iEYYwOMKunim+3rzfOl/P8gbvtHB5JBn7t6DiiKoM6wg+ZvmdqMzvTLS6rouzfQr/nZpqoLjVawL6lEeZyp/LZNHeOeW7IdI72vgrOzWpfwNqccZZT+YFmteTA8pF1+v4yrpla6FjsMYbGyhrRPrghDpQBi5mjJv1ZjtlvVN1+P6PXzzq3kIassZKUBrhqNpUuyuMeZ0PAOO/pt9w6XnxwRJXrbGyHt/dP3wfk6K4JVXG
 FF4mesfo
 rb/h6kNSJYIR3R1NWh1e7Gk0cStK4MIuFxG+8tmu2nc0fkzUqKx6DkLADX1wGDNi2IBlshH5P2c+0g1HBiUkILQkYaracG1hK+HxtIv2aV3ovNe0MtKORqGyUV4wmcwinceO7MOmgFgSxzBTw/xpLi+1eyBC93a5fJTrJcctO2FU7+ONr3EblDB/XyiYwn02ubuJtatRMmR82xqZaY8lxkWjUKppi4dPPI+jxB8tW6V4+MXPQQKYj/NDpTOvI8kN22BgGjAZcGi19Z4KG81oAN6N9RnBqyq9kTaWSmnYEihviddc9jM91N8KbcA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 30 Jan 2026 at 17:06, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> I'd rather go for a spinlock there, protecting these FFS_DEACTIVATED
> transitions;

Yes, that's the much better solution.  The locking in this thing is horrendous.

But judging by Samuel's recent email, there's something else than the
open locking thing going on.

          Linus

