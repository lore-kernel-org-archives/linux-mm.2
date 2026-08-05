Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0008FC55822
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 08:12:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04B056B00A7; Wed,  5 Aug 2026 04:12:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3E986B00AD; Wed,  5 Aug 2026 04:12:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E09236B00AF; Wed,  5 Aug 2026 04:12:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B12156B00A7
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 04:12:40 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 190031203E2
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 08:12:40 +0000 (UTC)
X-FDA: 85066499280.12.F01ACAC
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by imf28.hostedemail.com (Postfix) with ESMTP id 55725C000B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 08:12:38 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qvf8r0m7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785917558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9tI8sU3Lw9QYzBWqTxRt0CmjJbY/DDf+DIW/Y/dz+Tw=;
	b=q+CLL0lFOY7C58n3TPDY8GQvkAmUerq98X86i7A2oFxxpNI176of8JI6jbT0Jzl3m7Re5S
	e3+aw12Tzgn01g/TZ5T8gOlvb/rmZBrzspXWQ8Jc7tatmTp3aGmIKsDj40Qt7ZbfY55Mh9
	yYC9lpUXaBz0P5LdFTmpojBCtK35Aig=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qvf8r0m7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785917558;
	b=rSAuXBmix3+HWyzpZ2ZI/x5w4Q7GyVMtbm2EOgG7qbXU1FyJ+4dw/yz5vjkUzBWBCDiKYq
	lBBHQtLVvT0uezVJZ/VoBTd3IOzxv5iq0Si2MBNe9JRiE+toIOM4Fc8X3tI19CWoZf/02/
	AUIYYlXICFWJpO8xzDs5vzSR0VFOLPA=
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-c9b373d5af0so523081a12.2
        for <linux-mm@kvack.org>; Wed, 05 Aug 2026 01:12:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785917557; x=1786522357; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9tI8sU3Lw9QYzBWqTxRt0CmjJbY/DDf+DIW/Y/dz+Tw=;
        b=qvf8r0m7QzR7YqwCx0DCgsQoJY3RnKYTA7TQ7o8YN08KwFXHSCeLQxehAKUB4EL1T5
         peM0XjmGBJ+ojxR5zRzMiLkswp5N5Wa4L/V/mlWGWtERSHb2YvrtJMLXZUrfDntgi2L3
         oCuhrdd2BtZrtGHWgc9K3ey8nA6JKKoYvegDdOeU0I7sSFmE+ZdPe8HvObdRBHbWCb3S
         IpBcnQw0e2cQvDYtiUqy3XBOov+wJLRDrRZ+00q4+VmeXdf95OMOCuUcixef95ffmilr
         h95Vxw2q/bR0+7zd0t2JkUrEMELIxenA/S7jIiWID+/AjM5rha/x0WTEHV03wpstuTd8
         KhQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785917557; x=1786522357;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9tI8sU3Lw9QYzBWqTxRt0CmjJbY/DDf+DIW/Y/dz+Tw=;
        b=FZTNQZuVOp8wdt2RBf5iE22CDBKLU8AGDB8r3xzuYG6OFQd45IJXsEcssUO6uRovwu
         7CMkgXFBneFsUltdQTtHDyrX8nF4N1CJQ9unw24fYNOily4OU3TlxSIXh+m1LdJoi0Dd
         uNLvgywreIU7uYVhg/FVQJZUsbSxj894BN5mTkTI3sgTQfSLf0GlPlaZOxNgnqlAMXGP
         VP2dcPNJzYeJqOkAv/1terHLh2tswkCkWqOQnnLak4he0lQmb0Xsuy0Xy07YxMBSvWZQ
         iglByQ9UyPuzcW3VWSUkuEuibrdUKiLfFhpCRYImH1sezWEpLTV7WppGTXfYOqvISaWZ
         ypUg==
X-Forwarded-Encrypted: i=1; AHgh+RrXkIu1h0DH2qazZHGa7kB8zm9hy4qYn12VzfUba5bIc1eyTcNrPdAdZXplctcIZWM1SbCNxDJMeA==@kvack.org
X-Gm-Message-State: AOJu0YxKcMCjy5nVowzcHIvpv/ehyNBBcYiaxVvU+lBMWy8FW1/S0oGf
	9SCmja6kd3m1D3mbno3Z66zkSHNFEkKqvJmFXaQOfoEQCi3W0ZoWgIHA
X-Gm-Gg: AR+sD10Xyvi9IaYHyf68rPQsLCPlVY4VeZtBqIJ6OdRp12ucyuRoJtdZaYNTEC1cwiu
	niUE2YXbCupCfgNTHXKOHLwKhSJXO8P1MnRq4jbbeolgFRUk/4DQArqT6IqhRY+ImBLUTJb0Y4g
	5SSAT83A/V1mr42I/qDJsLJQ7Ir5iqtoYuwHQ1z9CX+dIlYTtqYI2kqFQUFw3dmTVVAVJgxGfp4
	WAHwIIESi4Vr0M9LfyUZzokBwe7cpbQ2JsmMKVisi0UKBD9GXXRGDcLzF4D45cHj/2zd+DyKhUF
	zF50omt1Ri4ZSbUu/tlz7LVO//1FFiY7KUZu8d5wLfgGLRIGStKmf/b2FmqwSKNJGNzQH3FsQMo
	Z6n35mI3rrMDOPp2BZUIhjx1IK/ujaJ//MislGGCc1RneKARvVTCfohF9W8wF9XpteERM8g+Pgg
	+geef5D/Oc0bK+jzuqse/1ZMOwhoNbg3lZJisheKbWHyvCkmDtUBukp7Hg+lAg7wI0
X-Received: by 2002:a05:6a21:4685:b0:3c0:b766:74f4 with SMTP id adf61e73a8af0-3cb85f4a279mr5957110637.31.1785917556844;
        Wed, 05 Aug 2026 01:12:36 -0700 (PDT)
Received: from celestia ([2402:1980:935:f4a7:6f5c:e816:9aba:2090])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbe7092b9c6sm1014573a12.31.2026.08.05.01.12.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 01:12:36 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: aethernet65535@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH] mm/damon: introduce damos_sort_type for re-ordering regions list
Date: Wed,  5 Aug 2026 16:12:46 +0800
Message-ID: <20260805081246.39417-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260804135834.86511-1-sj@kernel.org>
References: <20260804135834.86511-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: dq7dryszfex8j3zggq7gohcfqxrddbng
X-Rspamd-Queue-Id: 55725C000B
X-HE-Tag: 1785917558-919690
X-HE-Meta: U2FsdGVkX1+Ts2EZyd6W31FpXGTxvrEsbtGK4XOGjP8QEh1kVW8zw1UHL6CjrceCjyQM6CqmE8NzxDDomULgh8+ZvC/QLKHbhoE9eX4JJrAPsrVfLpZ/88yOrfzYA2evH5/hmT1BO4lHJkSxfi+49iq8e+iIa1E9PXY0F4qvy7fulPOqqfOXNwK12BT/nYTqcxlVrWORRyKmGngi3g8OS4Imh7O18f1NlFw1yeHT1RG1f4milBlHYc17dmtsR/LBpBjhfff8alBkDDQvOYa9vVdirmNoCzu4KpsnfIVTs3DWV25w3GtpQO0SWaNmG9FA/miIAD/JdHStBAewhcyfzdJhZRwky4ibZlDFWSpwdtpw10t+qqTcSCJVUbVTlJAhUcuRccUCbbPcR/ilDr+TI49vtl86GawbDkoNeVAYh47UAJ4M0RvOLg8R+JvF1yo3Xk6f9BFlI96Yr4KDY37gddfrHwUMsODSaVCpMvlXld8sSAqB0VkXq2cs9Esbg3DD7awEPA5aorAdvLa4oKUlIVjteGH9yuTe1BrIGzkAMZM7VIJhM+0jDWnmnh5nhMPu3UE0XY4nPpuHlL9y3d9n0pBNVXRPqZ8AkDs8Rfn5UWy9ULTA2cC9rltJcGY9jdJbv+zI12floLEzKrudpAwyqDIXdWkYDqCC+wKGg9Yat1b5KwgIoMJr+vjW35lTqMNnhQ1NJCxESWZ3lOg0ScT4HW8BXKHVAe2pd+HIbhxdQZlaF1Wek6xXx+BxMAPax+/6aBqhW3xIgJtpWGWzFoY5/gMAVi73Huv1HAc4Ng8JvBDAIMokX48hFmmOQaJI81Qll1oucs46KbJb53ILgl3uJ/Pt1m4SzN6P60kT3MbggPa+lMi/aqzrVjvvi6wKD61ATzIesoH4QJfHZNxBLIBXSHjJTNciierAGvWZFivLH72/Z+VAURGTiFehudDlEWJVKuHWJ6VfEANWY0GV9w8
 H8eN9zkI
 ZkDVlNui+Xv4o5+g94UmJqrexfp3TchKS6itHp+RAp0h8b2hYIAR97MOpT4d8UsoARo2dooocglF0n3w8Q7xb0/cm0mAoIP+kWCYwA2J01BIVblNjyHyrxkWmtpqhLTJ8luaePyCAPS6sy2wi+d1qAk+8WIbAg/ABFuCdhcGavZ71Ppod06mGM6tp+jRE1GQFkQB6mMLLypeTPhGfoS/By6LXbtNX2RyAzooVdRSqt7+NjpSCmg38Z2iiJj8ztHRCs2DT4JrU0Q53rIvRiiF7o4NfMw5GCkA6oKSSK3UkaCqhk1HIiZCA7ouq7oyCkSIJOz+dQ7ShjHvyBt0KdWfR5Yg+EtbJbSVfJCzxInJnn+2oc5KaP/vhbIyIE8B6bmMbQIUwWVQCyw4r/HSDgIoMcm01gmiuiZuG1br7JY8zbPpNsoJgQY621JMvn9ry1iwpNqoBKc4ssmC3JEP5Vj3uKVywpglkJC5UfmDIMiC7ZLof8ZI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

First of all, I apologize for the noise, and I will drop this patch.
Secondly, thank you for pointing this out, it made me realize that I was
fixing a non-existent problem.

On Tue,  4 Aug 2026 06:58:33 -0700 SJ Park <sj@kernel.org> wrote:

> The recommended way is setting the min_age naive, and auto-tune it using DAMOS
> quota or aim-oriented quota auto-tuning.  Have you considered using that?

> This sounds like very similar to DAMOS quota's regions prioritizing mechanism.
> Have you considered using DAMOS quota?  If so, could you please add why
> proposing this new mechanism, with some comparisons?

Yes, I have. And you are right; the existing mechanism is better. I
wrote this patch because I misunderstood quota.min_score and did not
even check the implementation of damos_adjust_quota().

Whether when implementing dama [1] or this damos_sort_type, I failed to
realize that min_age might not be such an important parameter on a
long-running system, and there is really no need to introduce
auto-tuning or a new mechanism for it.

> I to be honest feel this is too much for "just guess" based patch.  I'd like to
> get clear reasoning of the change and/or test results before reviewing the
> code.  So I'm holding the code review until the high level discussion is done.

Moving forward, I will ensure I am not "reinventing the wheel" or
"fixing non-existent problem".

Thank you again for pointing this out. In the future contributions, I
will try my best to avoid spending time fixing problems that do not
actually exist.

[1] https://lore.kernel.org/damon/20260628085155.20828-1-aethernet65535@gmail.com

Best regards,
Rui Yan

