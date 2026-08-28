Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2458AC61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 03:51:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E78E6B0098; Thu, 27 Aug 2026 23:50:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BF0D6B0099; Thu, 27 Aug 2026 23:50:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2CA66B009B; Thu, 27 Aug 2026 23:50:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D07646B0098
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 23:50:58 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 42ED11C1C14
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 03:50:58 +0000 (UTC)
X-FDA: 85149302196.16.59DA16F
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf18.hostedemail.com (Postfix) with ESMTP id 66F951C0003
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 03:50:56 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=X09ksLYJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787889056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2wKk+vB+goqKaLt0KMnxh7usyJz614ylfhLbmhKrkpw=;
	b=ydb1jCKO2FRRyk8QMU5BLJIkoiR2YHnURsdOilhI8QKRAsYlr3QEM+GP1FqAJc4M0RTIYq
	sdEBNW/wuN+Z9W3xbdSXnrzJP43ZB5Cu9OUyKKC1NmlCoaqBZBtPxXPdojFcyyd0svshTP
	+YHieW0BJnytpMWQUn4rqNVOVZQPY3Q=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=X09ksLYJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787889056;
	b=mVlW5Gsjk1rjZ1N4j4yE+rO20od6J3S2UYq9XKtBAB1yeW8d8Ve3TxHA96YfWpU5sDCn2L
	1ETEGphBGqb+5DtAi/QB7JIK1TixVHoyMt+tKbh47CKmlCfblqvNwu87C7T3+aWXW4YYEY
	YM5dC5jFbDtGp33BOP1vsh93pGDU4h4=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-38759bcd877so512510a91.2
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 20:50:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787889055; x=1788493855; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=2wKk+vB+goqKaLt0KMnxh7usyJz614ylfhLbmhKrkpw=;
        b=X09ksLYJFb+mCAPbxwk6yvBA7u2sw0/OTpAKPD0d40i5MqfChEDZSLHKeAuZTva1Lo
         p1q+sxiXfpOzMyHulwIqWnWdoNO5HN+RKMayZ2b0bbLcN0mUxvRhr0xtShhHtVWfKqjV
         xzwR1f/L24VKQ8LhyRQHseT2RU4k9a/22HBMkcFmmsvrqMLv/Q+CG5ewO2GF6DNxIYRL
         3ttpERidu9xRDUF6yqs/A+D98JAB7FhyHTxl498Mj3Gt7FqxmEps8vQzWCfqAsiDXwcL
         1mdwX1zkD2dE0kyPihdyNKP1BNAdWQ3nMznJ2XvmwhUCG+wlTjIHVXxChwEOHYce1HNR
         rhpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787889055; x=1788493855;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2wKk+vB+goqKaLt0KMnxh7usyJz614ylfhLbmhKrkpw=;
        b=KMweTurTJpnMxytE/PuVVoc7oNEBhZ8zqD1u1NvPcNOzdoD24BfjZixESjSOYcnL89
         ZzvDZ2v16XnZovblbadsAAAzRU0st3QElBjiNvXSR+VxSH/lfaDB7cV2GH11JOHVSKaI
         82XGCf7D7dRawTEIr8vtiQEKMYDUVo5TgtQsone1Oxcj3PCR3+F6Grg6g5I7Qr+sxgJY
         3AmdXJnNGGUvf4S9CBoq8h3Dj2Ou5O2Osw8eBjgfQzQUg0UKb5uTbiUSvK3SugBbDEN0
         JCQ553OcvZvkWLBTFqLi0RfJZMObYuwI97P6p52JOql0jmU+yBGZZ8dL38dhVeu5mD1/
         +4dw==
X-Forwarded-Encrypted: i=1; AHgh+RqUzrz/bExpKx66a5EcTzVG+QGKh/cvol0wDKq5bInwxthiLPu/Dm7tITksUOrVtaBkQQbgTFwV3A==@kvack.org
X-Gm-Message-State: AFuF++l4an0xa+rqnCZ+wx/FqX2xCOle0IVtN0qivTEhbtq8q8IfLdGi
	NlwqFj5xizfNk52W9yk9PtRicjpFBPrxc0JYa+kvio63zD73b+LQF1f3
X-Gm-Gg: AR+sD11ioAGgd9Jl+RY7L6oAiLMJaPrbfEJTyaNvllh2ybwoSG49WXmASsmZVuKxXuC
	inf6tlusW3hO5PIrKq/zX3XqJ8MPpezNL+iFtOudQ0QnNT6sG6n9KIxAXTypCPEwZxy8f2ikbnT
	F5koy9CbJwp31egqEzoLG2AHPQYIu3Cnvk9dpvLdsL+mV25mHWpv9/aMHFMvV44voaDhtWbaxhT
	BavRWm3oijX0FEVPYAHJNr0lffWSR2lMK9GRyq2fnQQ9hhyo3+8eMu65Om7E653eQKjHq4QECjN
	CxpCcRw7eyOiVh2pkwAPoHxvgtdLoAsTMdT2XBbN48vMR+Ec3yKq2J0Ln8T9aGWIp7nnU/sz5PB
	odAwtUZxt992uQBjAayWiZXolxkpcdLRkZBM4tcHXr/DJNvhDzTQp9dmQaul22NiQ4QyuRRUKbB
	EoBZVYtHgrHKOwWu6mrC/lgoosSHAA2BEfT/iCnJ3vHjgNc1U7T6hur9ar3y4aJV0RxQ==
X-Received: by 2002:a17:90b:5284:b0:396:4dfb:5890 with SMTP id 98e67ed59e1d1-396d0e5bbc0mr8463160a91.2.1787889055213;
        Thu, 27 Aug 2026 20:50:55 -0700 (PDT)
Received: from [127.0.0.2] ([73.222.46.22])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-142e0e0e67dsm1659184c88.15.2026.08.27.20.50.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 20:50:54 -0700 (PDT)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 3/3] binfmt_misc: document the field delimiter
From: Farid Zakaria <farid.m.zakaria@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, Kees Cook <kees@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
 linux-doc@vger.kernel.org, Farid Zakaria <farid.m.zakaria@gmail.com>
In-Reply-To: <20260826-work-binfmt_misc-delim-v1-3-43618adf8599@kernel.org>
References: <20260826-work-binfmt_misc-delim-v1-0-43618adf8599@kernel.org>
 <20260826-work-binfmt_misc-delim-v1-3-43618adf8599@kernel.org>
Date: Thu, 27 Aug 2026 20:50:28 -0700
Message-Id: <178788902862.3236768.2911438482058639296.b4-review@b4>
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: ieq1wbjqf6eaeyitqmjsgqp4tmdwx79k
X-Rspamd-Queue-Id: 66F951C0003
X-HE-Tag: 1787889056-845977
X-HE-Meta: U2FsdGVkX1/IU6V04ve5jOv7fQUDE2eXGX94UR341OJy/HsyK2+u8nX9pZBUyEAxq0M54N/KCNBZCsgp3+pEKV5II76LPQlU5MW/yOx/ZqWTI/82tsXyS5NhSS55vsF1X6UNOj7qjW8FTUH5Pmg3j9wZD1g3si5wSB7ZnE5ShAvatAtNSp/X7kBASdxxfsdcBy8sjL86xfZZo4pO8SZj620h4YjoIw7IMjpne65wP/WLbJd/bvvGtRIc5IgU5AFDYjkeE0i8JPDMiWC8c+VKzRRPn5Hrd4f7Bd5fDXUA6L072YbffnN5Jlsd90duAOhk36PPFPNYBSZ8fE8N6Kvh/qszOmI7cBVVvwHJdPAVh+tODdT/a+kklnrMLV7wzAOyVJMqt9ONNdJ/fAKmaOVz9Z0SWPfUaYz7v05WQMBczjlsNmDoZEf/Zdywf8xIUOlLMOGMqQy1lVjf/N6fmCqEwsVL6qt67MNjdlTo56NAIZGepDEpUcIVyFzFd0aIvjstW2V3HivSjeLhq1r21MiiJBfsy5bj51O6a1eeA2cxa6Hc4gEn0Bzcrg8eEruCXZEetbqo0lnhaGv5BTWAf2fMsdlTw/+RNVaO+cT509WVd4Sz6hxYjfGewvKDvZdOMFBPbV085rhyfNAIhSkxSJeXX7tNlRTxewRjDkC6Pvzd+GqzbDkK0T2HheZhq3bQE7QXCeuupXBneOIWNUaVRl2i+Fvb+g84bXhB7E+kGzMpCGkRuTGPuEplXQfsqWadwBDSqTiQbQs/QIVNICzVwpDKXHHTRb3vsoPG4AHNdtikcn3t9Nkh4J3vtDWs+LGdd/vVHFlXx/i7/GS5MXqaZ0kO/MT+T4KBX3D0qJ5SKzuVPeWMLZ1io2LqTh8B4NuzcIRlDRCEIq+EM/WuanTgNqSiA3MoUhuu5I9e/AQZ9BtDAd8GV8iVFFOPXJKHG3r1f3WRkUojpY1rrfrgjscB3KM
 zTTBVUsY
 QtPG4NRlsngHnLFW4HnN9N9pErsi/v2OYnP13XtEYaywja+K3O+wusYn43owuQaFdTmSMwz0UCWYlDTY1gMo+4Mk0Y1FkQS302BoCoHkJL5+YwXxOR7VXi0BJWLs5R8Zcsy2RgNlXC5S+WPGJrr7FyObTeRDLJIYZ5dE0zVcHfGCXz6ww8iTG/7ovBRDaVEQ8y5RAIgTJLfY1dfq40+NRWZX9qQNFC7yKok5JvDhkKAogaHOxE2HS2EAPhqMmKuHxtb42KM6pQAbBHwQ5kFXV3xOJzDCpT2ApoDIo/IMLetExQcP7BJYk9+PFv74p16bD+1cyY9MWD1rrCWcfE1/Ii57LGo/bDqrfLGF76HdX3OkHlMbnhNyCnpRBLjRtHw5uj32n+4M3VQP9GD9ii+1GQ0SdN8+lb4SnJHZ8YpM9lCN0tEVj9bBtgEqMssaPm5bRNuCb8NJy8d2/F4y9Sb/2+znjzwPk6jj07JOCERD+740SzaIM7dAHY6vaALcWD5itIfgkCHQFI9WNpzvwsHo8C7otqeQHX341nVZvfQUphzqiVo2j7ZLFWr8hQawfPXwsirmi8eUX7HxJzWLscfQrffW6LA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 26 Aug 2026 17:55:48 +0200, Christian Brauner <brauner@kernel.org> wrote:
> Document the field delimiter.

Reviewed-by: Farid Zakaria <farid.m.zakaria@gmail.com>

-- 
Farid Zakaria <farid.m.zakaria@gmail.com>

