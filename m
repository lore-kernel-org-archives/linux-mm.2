Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8DEFC43638
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 07:28:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE3206B0005; Mon, 29 Jun 2026 03:28:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B98896B0088; Mon, 29 Jun 2026 03:28:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A82656B008A; Mon, 29 Jun 2026 03:28:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 890166B0005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 03:28:40 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0EA401A05CA
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 07:28:40 +0000 (UTC)
X-FDA: 84932122800.26.408694E
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4234B40003
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 07:28:38 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=erDBmVyp;
	spf=pass (imf27.hostedemail.com: domain of michal.pecio@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=michal.pecio@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782718118;
	b=jM/BomjHNRBQFPaD/02lkPZkWw1MTtrnnRT/H8Nxx+Gu83Zdz+UI2q6kYxC6fYY0f87CLl
	SDOjO0/VgbRpv7iYrpKkZRMlWAtgzUI3I8ER7DxTp5yR6KwYyfrM5C453bxi3PG5P+wTXl
	hPPnuI8A8BWWuc+973T4PLn9FlpBZvo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782718118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lQpHZi11cKsP2uCr/CzXPM2KCFMIncW7KSkiCY3Sf8o=;
	b=lbF2wbZBSD4elNFujmVwfJC8kdBIIUsvYeYNM2YiuUjs5YvM0Laxojv+oYAQSeW5WIc8HQ
	wyxoQWqgQxeTuE6USFRz3zsrlzFgIqT4DEL3WBlrGG87oWZb3Qeca3/aTfOODYeKCM1WTZ
	YGjsQTDaFUCjunnhu759pVB4kIwCP+o=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=erDBmVyp;
	spf=pass (imf27.hostedemail.com: domain of michal.pecio@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=michal.pecio@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-4720f3bf164so643769f8f.1
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 00:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782718117; x=1783322917; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lQpHZi11cKsP2uCr/CzXPM2KCFMIncW7KSkiCY3Sf8o=;
        b=erDBmVypO4iM7yL26+9+Dj4Tg1KZFDmXV9k41NY849CU3gN/e0VsPYS0TNIjZBX23V
         sf1TOxLQwdRztthLQsQueynlBWXIoaxgJY4/56x7tFTMKO9GBN4tilW9StGJILVzzv5v
         5X3aIIHk5gZdEHYmt8y/yH1zRuF/eYtd3x/aJ91u+nD/rMkNK/UWdxCFMgUV9OEWvLzj
         +WEhZTC0yaAlDT3MUd6RLoSil7Qs9Q6mLqZE0hUPI/vpGSB9kicHMioMvXa4GKFBgp4X
         NSLikZ/hf4vRqjAjuvvZxqB2ZKbBKtJTCe4lBjlZkOxJF2CDyk1JLSIki7nEHOqmHj/A
         MOLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782718117; x=1783322917;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lQpHZi11cKsP2uCr/CzXPM2KCFMIncW7KSkiCY3Sf8o=;
        b=fytQOmafk2pcIepHPV7i9OfMrGMgeesHXagPxkRHZcnH/A6O9p1whFxe6H0tQLkqFx
         dm0zOgCTRroOEskCpO8L6Jgv5mrVO0JnFDHSsHUFa89LdHMHsI8Yjq4T61GA82ErFdMj
         5tYcTDSvYETQ6jD2xVXXLLLsx2sMmG1FA/rBIk/b63ajWh3HEe3049AIUMju41c1nwb2
         FHXB4yrmXRGtwFqhINDNmAwWu4NWgUHut2DdmrSGt+oBZkEAi0xsevgg4SCs1vnmrBpH
         0Y/X0aDhgfDU7VBsohXrlo3Qwd+a22Djuk8vWvEMaarOBrIv48vf/KmAvNlQ3HaGf2Yd
         /+EQ==
X-Forwarded-Encrypted: i=1; AHgh+RqjT+h2k0Y/32zzK+eTGn2fJ5d8PngS2Z+N35NDdVLMV4iqA5ejZ0jV95ljZq/Id4QR5kQu2dkywQ==@kvack.org
X-Gm-Message-State: AOJu0Yzd73DFhJLMLibNzpqcuwGi9Wfglf+y+Ogifupk9Y/BmqW1T7tr
	eqFH5V2FVil+J9MFr1uJX0GSbae7aaGE66c3aeuliZJklMKEc5geuubkTE4ZxnV4
X-Gm-Gg: AfdE7clLeXkMvr2DleUvmb2f7JeXDky507ePFeRCkoxaRWk/jUFFpQ5FlZGnS93IWz7
	6wHIEel3wo0i91GuhxbOeUd6LwzUwtya2YyqE8kF7rEE/xpg2D74Qzu1ASCdsUE3y/LkROfcPY3
	KceZTi31KDt5cSBKWQ211J1hq2SIkjk9z4dxS2fTd/rQfcEBV7/3xEzKMHX9ytmr4MNjWHvsFHx
	g0oZIYuqUp+eMCGv+LySM6yLC4UNB8nzyu0sLI7DQZeVQ+ab1fT9KDiTIrw/9E2y/SBzXAjf6NB
	xqrXKrviD8LIWkFKgdXU9irCmT+WJcdfyW1gA3pT3SRXJuqhoG7QQRI5kZkYMLD/lQOzzfEG57e
	zGbFMqzJ7Fww0zJNiq0iet12R+oHMskYgSeNpJNf+iat9DqCyIzGcZ06CGRmT2xHyGLgDgvcypZ
	Xzi+EuVw4XxdynlOl9iCbessQq
X-Received: by 2002:a05:6000:3110:b0:46f:1b89:999 with SMTP id ffacd0b85a97d-46f1b890a94mr16268450f8f.30.1782718116866;
        Mon, 29 Jun 2026 00:28:36 -0700 (PDT)
Received: from foxbook (bgu190.neoplus.adsl.tpnet.pl. [83.28.84.190])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-46d86960983sm40122019f8f.4.2026.06.29.00.28.35
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Mon, 29 Jun 2026 00:28:36 -0700 (PDT)
Date: Mon, 29 Jun 2026 09:28:32 +0200
From: Michal Pecio <michal.pecio@gmail.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: sanan.hasanou@gmail.com, vbabka@suse.cz, akpm@linux-foundation.org,
 cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
 harry.yoo@oracle.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 syzkaller@googlegroups.com, contact@pgazz.com, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, Mauro Carvalho
 Chehab <mchehab@kernel.org>, linux-media@vger.kernel.org, Dinghao Liu
 <dinghao.liu@zju.edu.cn>
Subject: Re: WARNING in usb_free_urb
Message-ID: <20260629092832.355327e7.michal.pecio@gmail.com>
In-Reply-To: <20260629092033.4a83e91b.michal.pecio@gmail.com>
References: <6a3eeead.7fb353d3.354599.b0b0@mx.google.com>
	<85cf5045-b52b-4aaa-a038-ca1b856b55f9@kernel.org>
	<20260629092033.4a83e91b.michal.pecio@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4234B40003
X-Rspam-User: 
X-Stat-Signature: iinmarf3dzzi8bxrrdpkutp37ujajfke
X-HE-Tag: 1782718118-140444
X-HE-Meta: U2FsdGVkX19EgzwRq6KALNRuDJbOy7UGJivQN9jHcGkGtc9Tr6TUyFqm+wFHBMDHFao+1mKjJVUjxyWOhZbNCE+9giDDnytNxVHUlqzjWDqptDMhXrn+WtQSa0Rx0xkCAJJeA38i40+JaBx7H85IfS7zacWKg/S/fQa+lHpCaz+xpR77DfLm1k6a4/DwzO74IVOzspMCBjVjBR/jUtbmU8S8s0xTaikQKbMZ61PGvLOSuihtvgabQO540zlFD1Sq7LnoGH73Y/mf9HsYcuGl452oKDFVqI5QmNdd6se0vFLQb5LJqUWawK1knJJWkorSAMMZm/F6Zj33a/pbpvtGRNIQ4OzLB0cbyVLnB5E3BvCmLnxo2/mIgXdj2ezBNV0Vg6H8dudneawkQtOaJLphqUp4g+SvqKwb0Pfs9Lz1CXv3+2Tuw9SIwgwU4/JeKzb0A6jAcDIajJbwkvYaMjKJzgYD7ZLGYTI293IPA/HW83lB74Ftu2exag8nS5g+XAfk5N1HfvbztFNduTSN2HC4SunHkf2zlcB7G1RhFw+hrZI7mF+mRzDTF8OgvUKlUc37G1aEA4U7pm57dp0TaAJk2eow6RaiF0e7nAU6cZrwCX9lWLPV9V5VLmLqpFo32rk8bq5bMBAc8F9Fvrr+jPn2rK5XS1no3UEag7X6cCQ9vjncwRnLp/04u0TAjG/VxOaFt1Ru/fFLJeR7iXU86GIl2vh+OGxEnLWeul+/yhsyBquLtMn8ywQx4PUoR29cJ0zy2W807GAPhf8vBQqO0oHrhtvUgbRHR0KzZmxmfw7ShU7JTqa9e831l/i9S0YT+515IOmzfG8cGHdiitVYNEqpuEiAXxrc3v5Y1JUPYLSASlohSs2u9MjwvSLZBL86WMfwLYeCeHCAY24zb1gfGv7VLTi76MDbNu4zhDKLbfrmKIseEl54Iiow9H5QhIDQVKZcKUWeSg3YoZ6lBfphe/7
 yNvJ8QyL
 z9dJtwV0J/3uTBQCbR1fXgTVNNfEts0Ux1I0txJUnc2r985ziVDkXFckqQzced14f/JXoI7GJeSdBGyMW8wEZDZRbwnnOUi/VETh7C9+CZ+0oXs2dVmUsHMCoDLD79TrGKBodo5L960WwSmb+JkxN712YCQMZT/+WU5p3i8nreS2KYwqeYN0pnoFWvAaEyIEWa22Kh5xIvtRt4OKSgO/7Ir/IivGmvw0YnVh1jP8xLT559oNHtRqCN8v9Kf7F6597irM4vHqKE32LRGQWZ06CUDK7tkhHuZ9+Du7whR5+/0W88vMHBGapc1d1L5gHug++2+78dqmXj239ptLUDxAEXwoKHFGPYJ2eHsadb+jh5c3/jsib0+OvAvNVUTNXsyf6EcsWvlvYDNBdcaF9GdDRc0Ytbzfj6bQhsoMfFkR+IB1Xz+XmF/8kVCwJvTRdPbfyoPtKRJ0mVfQ4yZMHCURMKhvUU1HMYrmRf4+q71o/MntaKVJO51GY+sOvuxCNFJvZpuHE40pg8LuPe/+nySw8dXd929pEBU3xDGxtl8WTA3AertDysSRsoE67SQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 29 Jun 2026 09:20:33 +0200, Michal Pecio wrote:
> The free(buf[i]) loop should simply be removed. It was mistakenly
> added by d571b592c6206, then a26efd1961a18 recognized the double free
> but attempted to fix it only by changing the order of freeing. Sent
> from .edu domain, so probably an automatic static analyzer fix...

Correction: it failed to recognize the double free, but it fixed a
different (real) problem that the buf array itself was already NULL
and couldn't be scanned for buffer pointers to free.

So it turned this NULL dereferenc into a double free.

