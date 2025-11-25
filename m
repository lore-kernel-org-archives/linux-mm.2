Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75B63CFD36B
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 01:59:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C70636B0012; Mon, 24 Nov 2025 20:59:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C45126B0022; Mon, 24 Nov 2025 20:59:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B83086B0031; Mon, 24 Nov 2025 20:59:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A72C56B0012
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 20:59:11 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D7C6F13B5C1
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 01:59:08 +0000 (UTC)
X-FDA: 84147471576.29.2C04879
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id F2ABF40002
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 01:59:06 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernelci-org.20230601.gappssmtp.com header.s=20230601 header.b=HysHLsd1
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764035947;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ySJz8oUi43Qr/jFFNH3WP1+LICJ9QSiDNQYJzoAfkmY=;
	b=T3oDa7NFD8acOwuAMjje7Jj+dR9Iqs3z+2FlWTXH/cCQQWb4Me5PTIehB4uwxPFiQA5zVA
	76bIMcyEgHifYdXqXqxly9VpOf6D8KuqQWf/5Uo5xzG4XEL/3DWc+gwBWFaDR8BxeNIaRc
	Zd/k+dhX+iwmCLqs2wZ0fKiHaX0P490=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764035947; a=rsa-sha256;
	cv=none;
	b=hfZ0AsvIWjQ1FLc0qTNo8EqM43l6EYpuTx0WE7g2bjieJniYyszw1rP2XnkgKbWLzEdBJ4
	yWvtHydMX7hHfdO/o9B2fynu2PreLxyRum5mj9y11twyRbUL8XvbqRNuFuAN4a9X0/xTnT
	IWzPBBy10UbibvCuDoELmQcsS6Q0hvg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernelci-org.20230601.gappssmtp.com header.s=20230601 header.b=HysHLsd1;
	spf=none (imf12.hostedemail.com: domain of bot@kernelci.org has no SPF policy when checking 209.85.215.172) smtp.mailfrom=bot@kernelci.org;
	dmarc=none
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-b4755f37c3eso3375759a12.3
        for <linux-mm@kvack.org>; Mon, 24 Nov 2025 17:59:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20230601.gappssmtp.com; s=20230601; t=1764035946; x=1764640746; darn=kvack.org;
        h=message-id:date:reply-to:cc:to:from:subject
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ySJz8oUi43Qr/jFFNH3WP1+LICJ9QSiDNQYJzoAfkmY=;
        b=HysHLsd1GtQntxjkxakbIQ6gmc98JG3u4pbgNu4r5Mf4Wb0vnDpQEpeSwEuCO7CF6c
         hD3zvtFXwphL8X16NjM/Z7izCOyCMqD0cPeJS/d0e/R6FB62OZXuojKeL8PBFZKIHUIX
         aepktBnX27VRZMUUw2np8EY8RBMRWdSMxTnF85txZCJBmxalvj/vP2ECiE+b7wSg4jLy
         wYt5rtYnZnay0j1VrthjZ0tBBBpZdySj2YI2VONlM0WwaVoaWCqmUaJKchxq5s2sAZwk
         f19+8SXGW+A5eD3KxCMOX+fvGcnImNE/AKWK82nNFt0IzNI+ktrMVI/OR5G6+A6Q0wZO
         ouxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764035946; x=1764640746;
        h=message-id:date:reply-to:cc:to:from:subject
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ySJz8oUi43Qr/jFFNH3WP1+LICJ9QSiDNQYJzoAfkmY=;
        b=aS7L8QufA0V/b7+sOWNappknQN13Lf+nNcXne0HUcZmMCcvq+xWKbAZClSBtNGT6Cb
         zb+S+/WKPXT5UeFDFGLRugqw2c1NUGi24GD6a5LfYS8auA6mqMYhsbX7lx0eDx2p+1EW
         WuembF0oyXG76Ul18mgfLxWQa0AubZWsblNp6dcRLxemhLq+77Y+q4vEaTBdsaouKBbJ
         lnHMYEyf7Ipfx/A3IkZ9gg9s3YDWq8NcyrzkYSQCRCbZ+gZSP9+fhZ4toHN2mhMs8doT
         HD5jOFYft8ZHuRE0A7pSZJyHKbeMzMYNAFWJgLIUNpByC0ss+ruagHPM1FRa2EuEnNRW
         ABlw==
X-Forwarded-Encrypted: i=1; AJvYcCUx4CXouxEimU9q4RByLfDr0QjQCvA/8mvRbPfhuk6X3Tac17NhqVku17wx956UZnaey0vNzXmgbA==@kvack.org
X-Gm-Message-State: AOJu0Yy1x6yc7pI0iue6nmZMFVKZaDdfP9jGrj1Z0len6YioLT3GyPgB
	dAojrQ1IqjcG6jQW41IogFtO07WY2YpFqL9NZC+FUuGSXIdagSZjS3nxt1fCRmVWQAA=
X-Gm-Gg: ASbGncshpS7El4W3thJWdft9XEAMUvEueCHvnCAqxnWc1sSSm1UryH8fJkRxmOw+NOi
	x9jnrx1S+B3k12aH4/k/2fkJHtht3IhfbWfFVYBGgD3HLkRJWMC6+eJe7iX65MYoe5P47XY2PuM
	iL37CDXfYlYd25C255KTTNHtt8K3rnR08oW1MLhZVI94TnZSfioI49/qQ6e0Tu4Sa252dt5tne4
	sN+jm12yDpPfVzY2nYAqDxpwmdE0tvpIXnqVsyW2sZI6mZYWcK7OhBtzn8J/78eQqV6e0qeInWO
	h8Q3JOzPRewciXPkVW6kBk8PH00z16B9FbkTB0A1ZoAm3zxhPdICSOh/2vxXcdeOWjOITr5g5N7
	3boHHkxCF3ta4WXFnRpzqxXBNmKO+JGeiMkU3ZqAvyD8BI+atpvkPInJj1P2iqSciYh78+WgpLb
	8WZFUM
X-Google-Smtp-Source: AGHT+IH6cKbVFrFyt/VNGnaiFrUZRL8WYuujZzlpyrCTDjSTpn5VWNnpXXmWuf/c3Z2mxxd4cSlN7Q==
X-Received: by 2002:a05:7301:4d17:b0:2a4:3593:c7ca with SMTP id 5a478bee46e88-2a7194d1b0dmr6382836eec.10.1764035945552;
        Mon, 24 Nov 2025 17:59:05 -0800 (PST)
Received: from f771fd7c9232 ([20.38.40.137])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2a93c5562b2sm7186085eec.3.2025.11.24.17.59.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 17:59:04 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [REGRESSION] rppt/for-kernelci: (build) cast from 'void (*)(struct
 callback_head *)' to 'void (*)(struct r...
From: KernelCI bot <bot@kernelci.org>
To: kernelci-results@groups.io
Cc: gus@collabora.com, rppt@kernel.org, linux-mm@kvack.org
Reply-To: kernelci@lists.linux.dev
Date: Tue, 25 Nov 2025 01:59:04 -0000
Message-ID: <176403594454.337.4411088799070097174@f771fd7c9232>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: F2ABF40002
X-Stat-Signature: w4r8or5u5gd5rh9negaedjtq8cwe7uyz
X-Rspam-User: 
X-HE-Tag: 1764035946-281811
X-HE-Meta: U2FsdGVkX18a7usZEKUBt7vVDo5ysV0+mce3GhDuwMaKvaojdGoQ6lGTvsuicnHzlfj7z/rEzSSXfS28yTi6Z+iGHT0c+En6uflP2fvG80aUi09CnGGOCqg5/yPsz5fDGV+FFx2uOAksJPL0Pg3e/mqtWHngQPz2ouTnQmwDrBkcw98PlDVNax0OFBxZcPpwC9qgikl6fx+mmIlZB3ZR8vhOOW2qnp+sHYrQrWvK4k4jhslbtSoxOyK5I4eImxzksBMJ3ale1V+VNP3DNDe05sGZFbBQ4WMjpuuSHMrfcJL4ICFvCiHeqqA32k+B+nUbMoE0GsYkFx/sit3yX3w9JKcoHXxNOOte8pYM0ghnN89F91j0D7yWoft4lGzNYb/Sfnn+RQ1GMdSa8dfvfiLdgk4/O2ltxZK/RHDb7FqnePnelmNAu1OmHfwCMxiAOSvdnUj9T7tp0ZkyjOIImB0ACP0frN8Xzn8ILxxoTIPmkbDn5ra7eEnfSgDqY3jkJmubbIps/jN11GCWNAJjBJpPkBnEANMvoCEXUrNv36j9Hv9BeATk42gEc7JPdDiKFoS6vyJCQUXS4Gr6dNxxRZzwJWSdRNXJu+k7qLsj3aLJjrr9+fwvoPA56feX9ar4JrKHKKJjuAYCN8MrHOLsijwE7nJe8iXOU6J6v4lg7DzfpBeUKohPRFqnjt5kUNabA10/lcN73OW+HPbq3wUdHCAurOrdAc1fx7RTlNhR8cWlODX5ISStc2tfY9Tvm4DeI6TxSqaVtbmZvkBITobpGtv9VgH+2u3o+/Wjn22fx/lWUphut3v1vK9epZyqy8rfU8R5ejURMk2HLEp3cJ0OlirLRP/toYGzCiVrhUqDiwcO3wDfd2Bjuyp+CANzB+6gqEIvjkWSQpN3zaBcGSJZIg/eUCQXo9vPauLuiqN0nTNSxsxbMFikJe20ZFQJR9fns85sf8qm2dZANzTUKGhVZgn
 Hsi/+xjG
 JooVi4WH+Xd9NsV7eBXlSQzeKREKWY0N2j3uEs55GWjdcjvrIl2wXveM+xdTefdRcpwpPmeR0SfzQSX0xzOvbFEUr9/3TAd2/naqWlb5oG8T/Dpo601y0wcSuUh41nWRcqZmVylFNlQ+yY6BWT7ZS7loB9jWw06zFv9ozoIIDt7vOQ+0KvPluLP7gW9KZEBjVkHop/j0KYnNHYWyVNWyK3ZF+ChU5DVN8A0iBo6bjgNzj4eAQDZ5v1Clyw05hsbL02AApuud4XvctJbb30GOKKPU0WkQvrjld2GGuY88Y4HpNos9GYi3xsaWeH3HAHRKSK1f1lTbPzoE4P64WskkoS6nnT9C7BBKsDFYjvobH1bADCuxAnJ4MWY7EaIVy5OfaxMIubt6QEccOkQYWmG9yyl2vjEudUIl/HjZYtju9bmS+Moc6paGIuymrxhxwHqqM5mxv6julMfPMlEDpO5C91+6j42Wcks5/MnsjaqbQLe5OxSPyumDTwTsAfNfjL8NgwIl8oAUFO3Hx7L8zlkajie7yTSf6cSUbleJyUBMNQ8jHEK5LbXhwIpFHQAjJhA8hWyQnS1T4FJrgRV5rRncGNQODj4kZbVOVU/IIZ5xYn9UUk16p/aFyAIFSzD882vbKYaIsqxFMzMG9hkE1uqfxq6rD1TWpv8rqhGiwrbGpkX3RIKRhbl7P6lai0mwfRfDhjnaYKpnUm2y/+oHA0YRC4S51nOmSOMMQhToHwJhCz3pP3T5KxVXrXOceqw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>





Hello,

New build issue found on rppt/for-kernelci:

---
 cast from 'void (*)(struct callback_head *)' to 'void (*)(struct rq *)' converts to incompatible function type [-Werror,-Wcast-function-type-strict] in kernel/sched/core.o (kernel/sched/core.c) [logspec:kbuild,kbuild.compiler.error]
---

- dashboard: https://d.kernelci.org/i/maestro:3da16ecb10e01489573fa267fa05ce5c8f573ac7
- giturl: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git
- commit HEAD:  7a1b17aedd2aad3a04a211865f048903bd47fedd



Log excerpt:
=====================================================
kernel/sched/core.c:4790:10: error: cast from 'void (*)(struct callback_head *)' to 'void (*)(struct rq *)' converts to incompatible function type [-Werror,-Wcast-function-type-strict]
 4790 |                 func = (void (*)(struct rq *))head->func;
      |                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
kernel/sched/core.c:4814:10: error: cast from 'void (*)(struct rq *)' to 'void (*)(struct callback_head *)' converts to incompatible function type [-Werror,-Wcast-function-type-strict]
 4814 |         .func = (void (*)(struct callback_head *))balance_push,
      |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  CC      arch/x86/entry/vdso/vdso32-setup.o
3 errors generated.

=====================================================


# Builds where the incident occurred:

## x86_64_defconfig on (x86_64):
- compiler: clang-21
- config: https://files.kernelci.org/kbuild-clang-21-x86-6924fcedf5b8743b1f5fa54f/.config
- dashboard: https://d.kernelci.org/build/maestro:6924fcedf5b8743b1f5fa54f


#kernelci issue maestro:3da16ecb10e01489573fa267fa05ce5c8f573ac7

Reported-by: kernelci.org bot <bot@kernelci.org>

--
This is an experimental report format. Please send feedback in!
Talk to us at kernelci@lists.linux.dev

Made with love by the KernelCI team - https://kernelci.org

