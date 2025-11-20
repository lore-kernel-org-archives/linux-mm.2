Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C25CBCF857C
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 09:59:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2599F6B00B6; Thu, 20 Nov 2025 04:59:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20A7F6B00BA; Thu, 20 Nov 2025 04:59:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D2316B00BB; Thu, 20 Nov 2025 04:59:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F012C6B00B6
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 04:59:53 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BCC844EB3D
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:59:53 +0000 (UTC)
X-FDA: 84130539066.22.8024CF7
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf06.hostedemail.com (Postfix) with ESMTP id C8D4018000B
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:59:51 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=R2jqaiLx;
	spf=pass (imf06.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763632791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mIODWrR7kj2FgENfGTn8a1wuC0pEHeF2hG1nTUsyQa8=;
	b=uwRdX/5o+f8ci9sHi7N/kroAwCnJOjC0Z91y+8ZS3+GFQ37Y9ehQdWBTMt3YVMn1fZz4zj
	sqzWW4gCkfyKieJpOpkcfINaSLad4Es+2LO+/CtAz/UbhhsgtwEw1CZbK9m00luaorxWKA
	q4nqywnBVhf7aH69VjrYAIcQy2pgQfQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763632791; a=rsa-sha256;
	cv=none;
	b=bBAS2bTJVZ3vlmwP2tAntvoYq1XCtpF3oF4WnoFBLd6n3x987v37HS8fDVesAZT+orwm8s
	s6IN5DeL2KdsN6NzwIKl42qVEmhSHLzNcd5AeZC2EeZxRgRZnQB46c6OY+/D1a8VyWY6vv
	7+R676rvDPQGFh+leOO/5kLEXD1QqP0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=R2jqaiLx;
	spf=pass (imf06.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-42b3b29153fso379742f8f.3
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 01:59:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763632790; x=1764237590; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mIODWrR7kj2FgENfGTn8a1wuC0pEHeF2hG1nTUsyQa8=;
        b=R2jqaiLxfQxwf+89gxcZBSWHjtqYuBhGVLPvKoMuNfqardvtzel3tDej89DWluGS0D
         6qiWKUhAfT9x9CucVhRJRKapH5WH0lhIoJCj4Smdz+ObnkKN6vJMWHaLAkW+z7FnW7wU
         PT56UHImdfQOVoNEbtGuoEW+Yq/dztAIEiSe2A/v/3zxq8YzJ6T0j4ll3aDvXtazysAd
         uJdC4FGZQmx7bHDnolG92gbQNJ5yU+77q09kHgj6bhpC17F30vEy7rXQtJ6ADpuzwUVw
         9YIhl4UK5DzkRDqqOnePpfqdAWfBG6gh7CIR7S77jFCK8ZcDriKGSatjBMDltwI3adXa
         dOoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763632790; x=1764237590;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mIODWrR7kj2FgENfGTn8a1wuC0pEHeF2hG1nTUsyQa8=;
        b=V8kPQCSUXADc07bRlSrdGZe+oNVb2TO5O2ss3dVJUPhJtNjhhMLSH6/sXru7LbFd6N
         hu+QftxLRuJPYS6MbHAnWkQluDF85OXPDgRFuFAnqpXO22WIEFd7sQOHch9XcTw3mcY8
         Uif7PbpamSgr7n221Ib7RsqlxaN6zI3rxpsOYGcz8LZojvOJVYV9yAB6HSdGqxcxzM2i
         7fDUjHKt/FmxTJ0/SevbteJfaTWs5bbxuiGQm80ZKK4Fgm7NieF9uCbNAoX96TKR3/or
         bDPnxVQjGGICzOekvXZO5kxk+HBIROWpXF1ZRyKrwar88ZPrwjIJRBv1Y+kcBle/E4eo
         93Wg==
X-Forwarded-Encrypted: i=1; AJvYcCUehVKO476HWiXkm+R5QW2XWtZ2KkI4Vu4lJEMHURALBLlnGZHUO+4nzjEnKJq1SMURsN0tEWkQpA==@kvack.org
X-Gm-Message-State: AOJu0YxjdkFsykm4dUlFo+n3y85RrreNlMtinxMtWbq3EsfN3Nh4ObPf
	MaIJenx3wcF/V1n2N1AU+OJCAYy/UBqj+GjfBtgQCzO0/GCigjKr0/uC
X-Gm-Gg: ASbGncsFcgPNM+s3r8eCAVSh5x+nAMlJEPf62XCfs02TRorlsFWHMjtyz/+Ph5uMERq
	yPKU68NrUdLVDImYn07KGCLX/ncjHYfF6QCagJYQsrpG8QpBeDEzdhEdAjuDq5jKtfcspN1HvKG
	TrDUF5eGdZm7+VZdQuHw+1Y66ovximqqsAFn3b9iV/uiueJp2o7/cLzb30SHCkGvbLUsUVM0Tel
	aIByuMUow9+L3Z+l4RNkkKh4h621pG5VIb9s4Gnut7b3Qv/YNlAZJIFgwigx6zrL9XE9CMt4g5Z
	JwuH7BgWjJ+cWMvxlXvtVUAPlROX6seHQ7z59xMUMrUyhGr3ZzQjxKXjL0mzRUbiqQxnvKPbfPX
	LSPJ1ZWzyp6caiPq7hWUO4HSlziV+lHEyap7/u04OOO0wOfjqa0FG3vloXEiPTbE2buGC88lwQ7
	B3tL22w9vSDv0W14zPai1JDmSdD9koMptsYLxSfHXJ54DfPFVol+C4Ug3+e9xpJx0=
X-Google-Smtp-Source: AGHT+IG37lZw7UpcsHmGZ/1ewOEV2psrqqY4t9wOw/ImHxPGIdO3yYJVfl/Q35dOCEa9SiO9Kt9qOQ==
X-Received: by 2002:a05:6000:1787:b0:42b:5567:857f with SMTP id ffacd0b85a97d-42cbb2b1d24mr1644470f8f.50.1763632790127;
        Thu, 20 Nov 2025 01:59:50 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42cb7f2e5b6sm4429203f8f.1.2025.11.20.01.59.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Nov 2025 01:59:49 -0800 (PST)
Date: Thu, 20 Nov 2025 09:59:46 +0000
From: David Laight <david.laight.linux@gmail.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, Axel
 Rasmussen <axelrasmussen@google.com>, Christoph Lameter <cl@gentwo.org>,
 Dennis Zhou <dennis@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Mike Rapoport
 <rppt@kernel.org>, Tejun Heo <tj@kernel.org>, Yuanchu Xie
 <yuanchu@google.com>
Subject: Re: [PATCH 39/44] mm: use min() instead of min_t()
Message-ID: <20251120095946.2da34be9@pumpkin>
In-Reply-To: <7430fd6f-ead2-4ff8-8329-0c0875a39611@kernel.org>
References: <20251119224140.8616-1-david.laight.linux@gmail.com>
	<20251119224140.8616-40-david.laight.linux@gmail.com>
	<7430fd6f-ead2-4ff8-8329-0c0875a39611@kernel.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: C8D4018000B
X-Stat-Signature: wxnbukztrtg4epiu5ibgwc4zpkjon1a1
X-HE-Tag: 1763632791-397792
X-HE-Meta: U2FsdGVkX18qot0V1nl2ueggtrp475GWx1JNWMeMSexzcjXJfF7LX4tp4026RdMGELY7yE+VdykNwNZFPIqFzIwwt+aPOT5EuHrM5Gfx8my9iDEk0cww5IO4RYuvO7rXL/qI2uaEPoj/Cb3h6Cyu/Zr54K2iPJiXlPLOHtOMpWpULUOWpYTE/5MGtENaWDfOUt+dzXGQXyeBLa4pgS4qrPxjgNeWTnSgHpbTOgoxA6O2Fk9l9uc3PWdhh39Ta4nBBJ0AUh9Ql2tRf0BDFKVavdbq5Nh0lln9+qtLe+ZNOu0SUcUDp556TAuOHxPwy/BgK0LU0OIF4m1scEPQ71ToqLMIVGbMZBmKGz/GxrtlxVLuoVcgMlava5MMHFLES55+z3SWoXvd7IbG6n7r5Ra2HejsqSd5XelKPHx9fsp7VQTqvIwMuzJa3h5UV0bmIWf/55xQtMYBww+AiNyrrXjnfc+LkpdapHAqXDgKOGpkzPlWNNEiEvENaHkE15ajwN3JKTpw3y/lmfY4ArJCe2QO7HiorirI43UAUWrK9tWofeV+PvxY0/fcvGrnEf9oT6G9ddzw/U9xtUxgXvFFHyQtx2o9gqZvzprTKCaBbut+PVz2cvy8693M1liRTFBomvmuKPzgvilBCt8H9dRGQI4lnDFMSBAFWubi1oFdJ6TvDfOP6WAK5tQseMrRHatd031qt1Li7LaG4NFejGaNWbZcAoy+ubDiKgw0uPQs7HY9BUhPXj78pe3+jtFSO0OT8b5DJWWu/avCmv1cL8/5Pt7b3uZfgKnCX0AETYnc9rOlTywhVEEAWbDfze1+7Eh2IGDVCJhIE3cg8B8EALs+z9ymBWxSWd6+nng1mNQuOQ8/dIuoapuhrxsFUsC4XmJ3M1uo0Hu1skiwGc7e2UlnCTRcOjVigwHiMsHYZlhduN2DvgzVvAfyezWOAfWQ+9nghGxi5i0BO4W6NL501sdnLK7
 bhYjHdI7
 vg6sMpe0Mt1d4ZXTXdWQaSj5zJv7QQ1iZM3cogK+I6NqDb6P3yVW56GTEnJwtZ3YVolFuzFX0deAZVjtj1Qps/hYJs9AKUmlSHnCQoFp3OK1f1eXhXvACahB+me16NJyWHhta1ea4HUmdpzxMhhHCxXzugjeGDOQ3nBDpGq/Y9dTpSBxiY18a7zd8Dy6AMudSjNTddwodnBGBoM3gwH9zqJYRtEP58QHkKS6ASLQkqRi3Mwf433/6BoDfUX0k0YiB/vFc2KexfkX+Ru66T5Wma31TUetwSR1Ut4S3ZCVP/JxzIa8atAluybCN23DnyfSd/aASWC7iYayvU3Dx5wfZX8zGPR5yYYfNTg91dyeingE8Vfx43/yQdCxtN3sF7IIgckAF4AeEO9xxvOZbpzfwEb4gW4k/Nt2Oaui4nXL2sG+Jq4s60pOLaJoHJMbSoAB9gDHCQqFRzFmlititMCYu+r6iHraFMjyvgW+dBeaJT+sYB7sBf9h0Hg5BX37wCQ9wnMzy35UO57hHMxA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 20 Nov 2025 10:20:41 +0100
"David Hildenbrand (Red Hat)" <david@kernel.org> wrote:

> On 11/19/25 23:41, david.laight.linux@gmail.com wrote:
> > From: David Laight <david.laight.linux@gmail.com>
> > 
> > min_t(unsigned int, a, b) casts an 'unsigned long' to 'unsigned int'.
> > Use min(a, b) instead as it promotes any 'unsigned int' to 'unsigned long'
> > and so cannot discard significant bits.  
> 
> I thought using min() was frowned upon and we were supposed to use 
> min_t() instead to make it clear which type we want to use.

I'm not sure that was ever true.
min_t() is just an accident waiting to happen.
(and I found a few of them, the worst are in sched/fair.c)

Most of the min_t() are there because of the rather overzealous type
check that used to be in min().
But even then it would really be better to explicitly cast one of the
parameters to min(), so min_t(T, a, b) => min(a, (T)b).
Then it becomes rather more obvious that min_t(u8, x->m_u8, expr)
is going mask off the high bits of 'expr'.

> Do I misremember or have things changed?
> 
> Wasn't there a checkpatch warning that states exactly that?

There is one that suggests min_t() - it ought to be nuked.
The real fix is to backtrack the types so there isn't an error.
min_t() ought to be a 'last resort' and a single cast is better.

With the relaxed checks in min() most of the min_t() can just
be replaced by min(), even this is ok:
	int len = fun();
	if (len < 0)
		return;
	count = min(len, sizeof(T));

I did look at the history of min() and min_t().
IIRC some of the networking code had a real function min() with
'unsigned int' arguments.
This was moved to a common header, changed to a #define and had
a type added - so min(T, a, b).
Pretty much immediately that was renamed min_t() and min() added
that accepted any type - but checked the types of 'a' and 'b'
exactly matched.
Code was then changed (over the years) to use min(), but in many
cases the types didn't quite match - so min_t() was used a lot.

I keep spotting new commits that pass too small a type to min_t().
So this is the start of a '5 year' campaign to nuke min_t() (et al).

	David

