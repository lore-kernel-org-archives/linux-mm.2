Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A567BC61DBE
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 15:58:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A88806B00A2; Tue, 25 Aug 2026 11:58:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A60646B00B9; Tue, 25 Aug 2026 11:58:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9783F6B00BA; Tue, 25 Aug 2026 11:58:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 754D96B00B9
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 11:58:30 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 05D001603B4
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 15:58:30 +0000 (UTC)
X-FDA: 85140249180.14.F7D0867
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf27.hostedemail.com (Postfix) with ESMTP id 33C3940003
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 15:58:28 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=G9Kj1xaa;
	spf=pass (imf27.hostedemail.com: domain of hemanth.selam@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=hemanth.selam@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787673508;
	b=bLoKNcX3rXKvs2B93WGKxVzEqhFQ4oepIAuTyCSt2DbZhzDeqOe7CH3U5c921hIS7KzZ0+
	c4zVCNP8Sf7J5rHmrwnxj+8hpOdxsCtG7b6kdoJJBwu0zkrjt3AkVgsbSwW9Der4gItoU1
	bfN/ammQirNu3FKWeexj46ZvGgdlYw8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=G9Kj1xaa;
	spf=pass (imf27.hostedemail.com: domain of hemanth.selam@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=hemanth.selam@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787673508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9OtZs5NBq0Z3O9dZTmybDq9m9YVYbLUmax5nexoEVpY=;
	b=1FGndR2wqUO8p3c1xI7+zYmxjZ3IiD1sru7CUc48GiPCBi/JIGfJ4EKW3onyrzfBF1l4Kv
	7HCExq0LbQJSyiu8lKbpyoxEbNvHXPUD2w5Aca4glsqQe3uWZhNUsznyyFtZZw2dHN1QVY
	BN0EkQqmCEiOkl2rKJqgbG7mrDGe1tM=
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-38d489b6b71so29039a91.0
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:58:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787673507; x=1788278307; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9OtZs5NBq0Z3O9dZTmybDq9m9YVYbLUmax5nexoEVpY=;
        b=G9Kj1xaavXHqg8SG3l26ZIKnCxqw7vi4NXTIZuEv/M4uNf9X4vuY0l/+h8a5mSv4ba
         Ci5CDbP5Kin5jkJl7cFmiMWV8WGW1XplTmcpoqniasaAgzIIG/d7Rv4lpN0xpOS2mlZe
         TywkifLTWebRAB7VDCV3Xb4j5iGRPpvmMVzzUpbuA1Ox0R6zm16MElw6KIKue0kJ+Hpe
         jDJFAOB2z4nggDFAwZ7guq01xdGr+RGrcoZ4b5M+Rdp9KS4eGwL8STgT2snyRK3sjJV8
         f/IN0HChN7X6EvTCMxjZtvtrL4wPO3Mzit26ri6ljCCbyPebaTsAziuUSEIgEjV+XU9f
         4Q2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787673507; x=1788278307;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9OtZs5NBq0Z3O9dZTmybDq9m9YVYbLUmax5nexoEVpY=;
        b=hKSRt2IkpADV4rNs1qlheJDVnp3674ddUjXK87iqpa2WtrYXD5TfXW/1e2hkIzA+2t
         o2cT7Fejf5ZNA4H8WX8pcL7WcH2vDD9DYl7n62GsauO0yVLkWu4EF4iDHlltYfn/dq09
         8bp0RCISBLs//PN1coJQKFUdQzJrt363rnd55wHEMv4DWW19yacyIcqHYpxRpbbrSZQS
         WnDRnqnN+K5DK8gOGaq67IenuEOU20R14A70elD6agvjwMYIJ6TBDBxzvMEL434o6OZx
         jo5soVlnbrtq1jzkZM/YGRQf69dzv7nsMzj2CYlS+mgnGwZD9BVlktw2W6F44muF9EKp
         KO9g==
X-Forwarded-Encrypted: i=1; AHgh+RpchAozdQ8s/eKDCTaA2IRNU7sHz9C3afaaFar28HZIPGhadU+rcNYt1YrbrbYeNkI5SlAyEQQ6xA==@kvack.org
X-Gm-Message-State: AFuF++mSiwqiWdsuX8j0TllPTGdCwZWo74+7Wg22ivfiTqOgJn2S0NeH
	ZDEvSJfcIXo1ywIAVf1gJSrDUGJeBCyGFPsmRK7K1czdOu3N7vSFCefi
X-Gm-Gg: AR+sD13ZzDseSzKD8YwwC0SMPwDEZ0G9xx09tFYPEi5kmcQrgfRTLochfPR1+lEFjNk
	0Kn+/j4kt+xhdNyaVYI7f+vmK/kTFg6rt7J7vXsUk6/cTaFt7duRDk1zo3MCWgHPLlKFSpYPRS0
	2c5w8djuKVsKOxlh4KWBWcZjBXHd87hvwtz0ZaSDcT55Coyok+fxdcTlrpyX9CngYoGPYcGasnp
	+j68GiSF+xznLtWWMNj5Fl2qnZa0v5q/2Wv9fx92ZdYztWkNfyANIQ/6yvOOroK45vRnxF3PMBW
	nTgcXqAp5iwFuaDed49NiX9L0COieQD8+zVOpdQbEfNnuXWUUh5MV9+KzUagJq4bAqgDMj/0nim
	XjDCl4JmwwDv6QMjePtegsSomrc41TYSp1awytj93rWzRhFto3nxTwA2dI3YO7nAsn6tqYMytjv
	TYXzzKEguhDo+GyNM+FyGNaUnpZNlsqF3Kfb2LNqdYr6dspv3WT//cCklz1RCxxJtYaZrN88tew
	jkpxEjateY=
X-Received: by 2002:a17:90b:51d2:b0:381:6c5:3f63 with SMTP id 98e67ed59e1d1-3966d21833dmr335850a91.6.1787673506904;
        Tue, 25 Aug 2026 08:58:26 -0700 (PDT)
Received: from volcano9f8e-host.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-141a9036c85sm148587c88.9.2026.08.25.08.58.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 08:58:26 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: ljs@kernel.org
Cc: david@kernel.org,
	akpm@linux-foundation.org,
	shuah@kernel.org,
	yury.khrustalev@arm.com,
	kevin.brodsky@arm.com,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] selftests/mm: remove the local PKEY_UNRESTRICTED fallback
Date: Tue, 25 Aug 2026 21:28:02 +0530
Message-ID: <20260825155802.2804785-1-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <ao2nFqGevXIa3l4c@gremlin>
References: <20260818114945.1312987-1-hemanth.selam@gmail.com> <20260819074717.1345749-1-hemanth.selam@gmail.com> <fd193070-af97-497d-82dc-1f0fa1172fd7@kernel.org> <ao2nFqGevXIa3l4c@gremlin>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 33C3940003
X-Stat-Signature: 5sa7htji3uxq9b4bq7jh8uxwumnnbdh6
X-Rspam-User: 
X-HE-Tag: 1787673508-125105
X-HE-Meta: U2FsdGVkX19FhrafmagnM4Qx98MjSpumIRQpA9EMIQlIcH1mrNSWB2xCpU0xQk45O7RejSS+oUnyw6TAsz+28xa3t2trNxsA+dKddOIRcoOr4uPt9URCe7PzOpjGpr5aESxtCWd+Rt1G0Pr2aauNYHI173ieQr1reRiJ7uU4Qs21yLrwd6r5MSX381e4ICi/AlMbvBC2eWIM6kyCgaj1AF03z20V4GcxYXpsp4UIMFBx0tTJCqE+aJ8ybkkKOwY5zJlB0d2TTnlfbNQ9DGZft1SJT/+EAjnE7Tg3IBJFOW+MMo03YIp/OmoW9goQKTYcdkaJActdTvs18vUExwkqs+XTpX8mf88ddUM/3THIBgNqP2bE0IuEl6TD719WQTnVm5lxdWwyJ/ZSjqpwPYqjo3TNS8lh4KLrGkXfsOirMlAuDfvc27m2qHBHf29OS+uXJY/HHV41W3gfVI0/0Zm9exw1Jhh3AoEIAGECB4uqiabrGkkuqL2ljfHdsMMcc2SGRWanWX9cUTjZ9hHPlVEYtlmzLg/dEDdyM8YBBDup0h8AcZHv37u9pOy8iJ07RfDCRb+cq+SJ2mp/HHioKStlVU8YsbdDrN53J2//xM2E2Zp7PiUda349DL7JtIK0xDfUT3BebF2DnmsNpJFmPbNIKU8BRbFp+9yWFoFLgrQa+DhOEdKrmssGgNcVvfDgRS42FaHUNgbfKCGTlK5H8UqZB3jzNxJJKRKW7fIWG5WOAXeqA2kuVXAhHI2dTXH6tvO7e4fBbVkeiJ/bSiTEHwF0TtEFMCDoFyu4mJuhn4SVre25G8IO1HwoUNWtU3FiVoKI1jaexIy3jqVyNQuhIee0gh2rjsNPm+lpHy/Clf1pzBuGD+Cl0ePyqWh1F2phIDo4Qj85pBoBdoo9eVRC4e4hlG5rDb31KFMFOCMxmzWz6VdIQnMlj/k5a0Kj7izNXvdpB1ZhCLsa+3+5+3L3Ex7
 lV/9+JSH
 imO0ahJ1/oaisUULHGgb4o9vNyfWh9ivQ7b20jtV31OX9FccL36w6CL9bgi+IwcnAO4Mn+7xMMiG6gENVfJUySCx8xCGguJAJbZjYms75VuWafVJU6JvO8fXSQy+hedu607EnDe12wqgZqd9bIT8jCVlTivtl3YMTddfus+HYhDaEkCXdOAi5hNd/LThggzlwkHn8b1p2alc+xOFltskVa5/vQdaF8YDsr9uapgUK2jXo98CPUvjZ2x3UWW40ICekDlO9bpstR/cFR3R4klA7xWjn2ZJiCcm4gIp3Fm74rPP7mibQJvOY8sxU2bNai8sJzf1oiyFbyrhzE/8Up2T6bxel/9hPx6OgX9n6E7S8AKLIemKj9FkFxCI99Si/eQi65qSOVA5lquiSqaQ5FkjbiaS23G7C2qw2UDzUyQmo02jQxsyKfMVDee+1CLhcu9uas97bzzWlDKpsWh+d4Yvegpjfe2vSTtkxQVg1l1EE4TSg/6Ejv68SoCXAkkrSpttbWPOO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 03:36:36PM +0100, Lorenzo Stoakes (ARM) wrote:
> Since you said load-bearing in the last email - I do have to ask if AI was
> involved with this.
>
> If so please adhere to kernel guidelines:
>
> https://docs.kernel.org/process/coding-assistants.html
> https://docs.kernel.org/process/generated-content.html
>
> I.e. add an Assisted-by tag.

Yes, it was.  I used an AI assistant while tracing the include path and
preparing the patch.  The builds and the cpp output I quoted are ones I ran
and checked myself, and the Signed-off-by is mine, but I should have tagged
the assistance from the start.  Sorry for that, and thanks for asking
directly.

The respin will carry

	Assisted-by: Cursor:claude-opus-5

I will send it as a new mail rather than in reply to this thread, as you
and David asked.

Thanks for the Acked-by.

Hemanth

