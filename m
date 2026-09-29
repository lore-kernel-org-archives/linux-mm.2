Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34FC2CA5FA5
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 20:59:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6A3B6B0088; Tue, 29 Sep 2026 16:59:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E43906B008A; Tue, 29 Sep 2026 16:59:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D580D6B008C; Tue, 29 Sep 2026 16:59:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B21C86B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 16:59:30 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3A0BDC05C7
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 20:59:30 +0000 (UTC)
X-FDA: 85268015700.24.C7C3AD0
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf31.hostedemail.com (Postfix) with ESMTP id 6E8B020007
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 20:59:28 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aT7xbGNi;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of med08elkadiri@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=med08elkadiri@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790715568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T6zBsYuvkhCSldzaWUb/rJ1yx0lBA5YccYiihjP9u78=;
	b=Z3aUqdB1u0uPYFcF0wkUQ1T6FjUXYU2yusP9wMguUalcvv/HKUhlb0aMVOKCkUf25CZ/Zx
	xWo3dB0vjMlV6L3eXf46p64+l97Hb9P+SkCdFtlpCwQCrjgfhJ30RUOt9+2Y2HpSI+CPlh
	3JdeL87s7q12F/64wT9iF43PttKP2Lc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aT7xbGNi;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of med08elkadiri@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=med08elkadiri@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790715568;
	b=bxemxvDkWSqOESIUmDo6X5IT7oi9fZ3KhxOHVe6IUC1n5QBSn35JaGp7mQwGAXXEXsq5if
	imGOpL9WEq+aaKojlFgc6s4QEIRO6L/6BP4uvou7v7KSHgefmUdEwGHW5Vbh0TIt+G1trC
	ug4W2V+vCjX+zD3vd5ogY99JNSTtMAc=
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-4a00713639cso19203505e9.1
        for <linux-mm@kvack.org>; Tue, 29 Sep 2026 13:59:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790715567; x=1791320367; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=T6zBsYuvkhCSldzaWUb/rJ1yx0lBA5YccYiihjP9u78=;
        b=aT7xbGNiMCTK/a3ECOSnD2B+7JYlnWm0D/iui9jOP8BIZ5TKsgHDpHIY9SRDIy6STg
         k3+Ic67iO4k8S+QhQpUmx3x7u4Tlwuuf3vQX75CEcUB6XH9xg0x8dsdDEJGQU+FyuclG
         JRePep3BxDpzjiokAMmXqT7Ak3USERDqnKZaMjJ108wHbktENFWVRlsOFd2BnapQnqes
         MXvq803IndPOJ7WMqL9icwHIKFwjx+x6NVzN43JUfn+tlgSqtf49W8YV/LRQs5M2azFD
         dNkfIA4gVraz3knP6uWXOtM/ZN4vwDI3+XZtvk3f2JH8u0E7UShy6t6hi1FNl6Nd80gd
         I0NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790715567; x=1791320367;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=T6zBsYuvkhCSldzaWUb/rJ1yx0lBA5YccYiihjP9u78=;
        b=GQlLvQQfGKHp78CdbX9B/7iAH0/Z4kWMsgdIQ5p44u/tnhaFIDIodoB3yAGeoJe/go
         1JwarMk5qfH5jZIdTCaVz5p23BbeBQ+2rjg0i+8bgMKwf5D8qc7j8MV3XZRr8Wha4c1p
         JD9lauQIFiuaeAo8u1/VODLgmdW7tQGPyXAatV6T+o6w4SyhEYaislZryOWi9pWxKqbV
         pJGDalGf3Usk0kHCxmvE1hzPSU1tcJUpB6TgqMsgCsZIzGzoVpythfterPVyREa7hm2M
         TDl9HCfkm0Wg+16QUQdfri5xymGq31wkv5kLGJDqWLqYQg0IuEdSOew6BXsNjcGXdMhE
         T2cw==
X-Forwarded-Encrypted: i=1; AKwUvBwshVVRomBlyUsvVAgC/M8Q9zl9uxl5p5D0r3OplFY6SQeXBuSHChkr4aDCuVdDgRp4ORmtsZ96BQ==@kvack.org
X-Gm-Message-State: AFuF++kq8qwvLB5t/ox7wwHeUavgBco7hO5frvE3RsKWasEcMtEgU9Od
	WNQW1fTUv2T+220fjiiij4HO4we6RNCSj4U1jy50W4CibGNmhB2TWJc=
X-Gm-Gg: AYBFou1xw5iCJTF04HMQCg/Yl/Rjg3uOgXPD7AxMhyol0LaFGzw6ShoRCFLotj/GMDo
	kHYLP86IDJ9TTUK6eaestyHzcBC/+dXwF0e4+7O/0/afmDHc3XjMsfGg7D+oVu6v4Yoihfzq4jh
	cBuOci9XbqQAeIjhEV4R93CJPHSnQKXsA4v0SdJgxJgwGm5hYh++Q59kBRd5xzq8ugNI06egofO
	jPCsuM8/G9ITSy+w2w+Fn6BIW9zdYg+lmJ/5nen+hveo9ezS9D535pswjl14+WwbmB+FkzCi9M1
	Rry3y5lKy8kw4u5F7AFyWZVsQQk0yhu95SHJd7HAhYmCcdTbnP5LbWLepBJNPNpmw/I+I/5TEHf
	7bTQmA5qSY3m9CBtmkwchOqiAa07sSVv7TFpaEmxtmm2NOdBXxGsJlFP5YGpWd1GJzW1XLSMGJY
	rrct9WMe/Mteq/KZksz7bNcbX08paSzlRHh0e6fvo2ZnU6K7wvOtMJZIEn8pQdrZVEGqMg3O/v3
	y6ddczhznNwHy24ZUFwV15HrR7wPefInPv/SM3umnU2q4vW7cslCMorlGf7gM4w5U8HEblLd/mp
	s9RCqzU=
X-Received: by 2002:a05:600c:c48f:b0:4a0:dca:b78 with SMTP id 5b1f17b1804b1-4a0151397e3mr4412245e9.27.1790715566870;
        Tue, 29 Sep 2026 13:59:26 -0700 (PDT)
Received: from Ubuntu-2604-resolute-amd64-base ([2a01:4f8:13b:86d::2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a014217216sm26857035e9.14.2026.09.29.13.59.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 13:59:26 -0700 (PDT)
From: Mohammed EL Kadiri <med08elkadiri@gmail.com>
To: gabriel@krisman.be
Cc: krisman@suse.de,
	hnkz.64@gmail.com,
	akpm@linux-foundation.org,
	hughd@google.com,
	baolin.wang@linux.alibaba.com,
	brauner@kernel.org,
	andrealmeid@igalia.com,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] shmem: fix unicode_map leak with repeated casefold= option
Date: Tue, 29 Sep 2026 22:59:14 +0200
Message-ID: <20260929205914.229355-1-med08elkadiri@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <878q4jyf1z.fsf@mailhost.krisman.be>
References: <878q4jyf1z.fsf@mailhost.krisman.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zxgsrp19zw19goioh9yuqajmmswy5nf6
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6E8B020007
X-HE-Tag: 1790715568-895645
X-HE-Meta: U2FsdGVkX1/WGJHuLYJlOFJ/Rd9hXfXevrrTRN/Lq4ZDspP362nGoWBE1YaCxHhGDNrHNMjfy9lJagGThNvG9iCoCvneLN2O7csmrE5Wrlm8p4jbHGt+z6fC6QE1WXUVl73GXYZJaHlvpns7Th0PApQG8JEPN9rpV7/bmdKG91Bgecus3HpCff45z9GHEZQEKTVIPIDLyBWhyCJvOU5/VAkhNXXQcwAOXp5phtYiMftJTlO44CqSGKZaCPnFsDNGOs2e5lRfrmF4tDZcVVbyFK2Az8JcxRy6dhGa4YMcsGRsuAW0I0oeUTAjaPxNelB2ywmvUdPERlmJq1oDd3241OHOX4VvcIisxxofUOYBgNyTduXdq827zFzg5JPvVsqTUXV6dU6scNWzln1N5lFOMenDuPZ/XTi/L+cPUGXFM+YOQ8smjwU9XAyueQ7evEyhy6OCPWXUMhMN5sv1Dw5Da41MTm6KnxsfXJ5M0Lc6FZQhtHwnDlQA10L/z27yDnZ5IxS+aS6L35dICx4XfUqrXHPTVTNYvJMkbTQZt9ORpjLcuqccDBSHJs9YZGyZxuauneLCRwl075A3gUazET4/EdjsqfSfiZ5XDyvoMsk4AHYXppgfYwlyt2quv7DlF2xY7IYrQuLmmle+Fa3xI/7wcP9vu/JRYRE2Pp8WrVm2kg8S3wcJKFj5FjAn2ors84I7n5k7pO6KEFgd7irBl6MYqjQL/oW1JLQencvm36jrOMVjPTgOaTV7LtvddtTc27hnyl4UoA/WfxFf2WQ87yefOrx/U8loCZ5D22AiXqRv18tPkZj3pZsstDREHpfJyz9d+JRe5VDj2FJi/6igpPsXVVjU3Y3C4RvB5VUn9xD3vq7OlZG9mxHGdRePA3vYdMi/d5jS73vnlvXMQEuK1A3eyZNYuDA1+cwUI/1Oh3Oo7u1CELu+HEKFzoHWID02qWVyV8RCQhfcVHkLwZtvm0R
 gDNvehaV
 OWIqQZMfMiWqUpqSZWTkn5qpErVKfJAPhk0wu5FXurh6LcRGs69pK39sOlKtpOH/kqEC8XSyALuDovYMTLoBMJyVqEMBAPd8oemxzmem/k5mV7U4au+9T7EBf7YJxOKdzYM9Y+XN+uo0KPt/tL6VZ0kCxPJ95lbN1dJDB/wXRx1LAVWIJr4n1aT3Ufbm0TYA/2HyKPm+LYdnNmP//LA6AoSDXQq0omEe8cWPxKqSXHqZUg+/R3tLkMbvn3Xvl+x7GeVdqoS8QFm7KJEIkRmaBwzfJzs1rqTivPJzHuExe+2Zxe/TL7JVyKdcV8KROLhLUgAYcOKLcpcO4PPSsbnEKHwDEYoSOJU1ms/A4L/bSPAdvYBMJFMG0VD1d95q6KFqKwbey3gbj6FwspANuLiLjWno90hF5edSz7eHH5Z7tkbcT39rN+552Ei/X0oEZojKi4aH3DKlEzvUPt2eSAF7rsGH+Zg4deL6kRol45qjo7DbcSyLLAR7O3e5ll/QFN3SYFWF4ihgc3afdOY8r0aZju1MRScCJqsHnk2BhJwndvwHS9GWaCtzf3FBpuAhK6QQPvLQozKbzYq0Lg3sKtcvWgDorMZwTqUR4h3SPaohiiC9JjVQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 29 Sep 2026, Gabriel Krisman Bertazi wrote:
> IMO, nack, this is not the right fix.  There is no point in accepting
> multiple casefold parameters and we shouldn't allow it.  If
> ctx->encoding is already set, we should -EINVAL and fail the mount.

Makes sense.  This one is dropped, since Kazuki's patch in
mm-nonmm-unstable already covers the leak with the same unload
approach [1].  Adding Kazuki so he can adjust it if needed.  I'm happy
to test a new version.

[1] https://lore.kernel.org/20260827152516.805622-1-hnkz.64@gmail.com

Thanks,
Mohammed

