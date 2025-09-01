Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E32FDCA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 08:06:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47D388E0015; Mon,  1 Sep 2025 04:06:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 427778E0002; Mon,  1 Sep 2025 04:06:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 316D38E0015; Mon,  1 Sep 2025 04:06:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1BBAC8E0002
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 04:06:08 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A301C1DE9BF
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:06:07 +0000 (UTC)
X-FDA: 83839948374.24.E907435
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf10.hostedemail.com (Postfix) with ESMTP id 64656C0006
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:06:05 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=XdDiS62T;
	spf=pass (imf10.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756713965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qAL+Ft8jZKINEz5jqSKOTaXOoS9hZhZen+9WCiONySg=;
	b=7AzhwhAj1JKp63MZiEe5eFcs/KBKgARjuCvI/ScVcEO1xo71La9X8Do6z4DlHVGB0rig2J
	CxkrzFQrhy4cxDh9lUya8FA5DuBts0Op94thiujaIen4LP5dYRSL0+vuEiYvHgINQa6KYH
	QTxe1UBJz9rmAkpQcQklWtB72Rjqi+E=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=XdDiS62T;
	spf=pass (imf10.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756713965; a=rsa-sha256;
	cv=none;
	b=1uqM8X+JzBUyRq6KTBDU5lj1VebntMf4YCsP42fzqSjZP4/L60G7G2/q0eC10LhCRAbrOn
	noXfPE0jJxXzFNLmQVOtMtL3V1Hp+wZgYGI4agrPsylpEj/5eeVF32CrHazJvmAKFKS0PB
	7qcKc/P9uUBMJi2LsNTz2CFul6TvqhA=
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-afee6037847so615109066b.1
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 01:06:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756713964; x=1757318764; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qAL+Ft8jZKINEz5jqSKOTaXOoS9hZhZen+9WCiONySg=;
        b=XdDiS62TFP1PxS5HWumjgbP7hW8EKWBC7Tnta2kQWldtD/rwQBHaqh8u0ZDlekzw4h
         NOSDKRECrZKYRGSWjPRVXp5p73zEZGmQCQsJe83Q4EAF1wij9CQYU03T/+jVeKFX/o7l
         5MehcCoeIYrss+ufwxWzXoMiN6SEARFdyltQrpT506XEXVncj2WPLYChA7DAiR8bPgI4
         yyrzbRITyqISOWII9FXba8FUwf8V6v3PWGcxgr7w+famS6uAEgNozYCuYMxqK8B6aa7X
         FntVEnjEzHTR1D2NwdpSUhhKA8PR7gRsmGbmf9HMszHIaQpLMOWFYd0t8WgvQJJMnE46
         M45g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756713964; x=1757318764;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qAL+Ft8jZKINEz5jqSKOTaXOoS9hZhZen+9WCiONySg=;
        b=STo+pRe7ItRI5NdKyFJQeUm+ZvpCLkqo43rI7MlnLKw0grefBbN7Uvew8X2r0uL1MB
         JVl4or5hVzzS64qxMIjdfqsV60NYwWw0ZSLQ0L+gpJhvUDyd5lwaoG7MV6T8vVWiRB+0
         Yez9nAkQRSYdMQ6ZLXYRNBHxlG/WGV/fcT1EZB21DPc6m0pGA2u3edYqgy7S0V+qfOTQ
         oxoXNVbrR2R8AgKqBO53YN8P27OHHXaDYwlNa5qBrp6mdtxd+ilfR0qpHEzeyACneoMD
         Mc33hEgBjJLGQoShiYcqGcNg9hGrDvIBBarM1QTLdbkq9zsqGTdZp9OFlyZ8gPVFuhGl
         8OIA==
X-Forwarded-Encrypted: i=1; AJvYcCVTGp4vWoqt8kHLqR32efz2hjwDPDXIoq5bLxggq2hW1dgHCKFzEvmq2aTpsTNs2HvWo6rfR8M6dg==@kvack.org
X-Gm-Message-State: AOJu0YyJv0yvDrUZU1JYuO1F4tBuIBHFlrVAf875ilu2hfsbSEV2iO8x
	JhVOP58ykfOnPZrLixCAhZDPXAJfjUymEo2KAW9+G27Zvq8/gzyR6wxWFPc9DSNRAqDpwkew3Ov
	xgxLUrX8wKl3Javb6SPMU7viewds29QafL9xpKlpntw==
X-Gm-Gg: ASbGncto2BoUVXWP72d8ZqVvrpGCG1dfNI/MQJclN6nsgaJBrA86JSYKNfm8y1nUZzs
	66gUgJvRV2+w2jk3L+FgiLdh6B5waNFUIvOWy0JjoWXyr6UoKtzrVL13bgAhh4xukFfxxLTWhSy
	aRzi8xRPtIXMoigZrCbSuwoBhlzbMGLwlqhxMFxF+hCfUc1RQRhBd9UvO6JWnf9b0RNwwmodQJ0
	+8z0EQtG5oCA4ednm7G11GN3Sz9qIzLXY6qIQcC3rfyXw==
X-Google-Smtp-Source: AGHT+IFK/vpnhnC8MFCfb2PlngGVphNQ4y6sY8x+yQGgbEfQ7yDgJFs09MGa/LJUiNzBGyccnGU+5pXcPn0H2ulkhFc=
X-Received: by 2002:a17:907:7f89:b0:afe:d62a:f053 with SMTP id
 a640c23a62f3a-b01d8a322c4mr662439666b.10.1756713963933; Mon, 01 Sep 2025
 01:06:03 -0700 (PDT)
MIME-Version: 1.0
References: <20250831093918.2815332-1-max.kellermann@ionos.com>
 <20250831093918.2815332-2-max.kellermann@ionos.com> <day257vhz3o7hepucfz5itjvdtp2k36hkqdg7hckqleb4jxyku@rs4rs3zhl4hn>
In-Reply-To: <day257vhz3o7hepucfz5itjvdtp2k36hkqdg7hckqleb4jxyku@rs4rs3zhl4hn>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Mon, 1 Sep 2025 10:05:53 +0200
X-Gm-Features: Ac12FXxX58JRZPaOdEl4T5aT3e1fpiWibxYF7xAAx6MHZtWjPDWsooQ_zsQAR-Y
Message-ID: <CAKPOu+-ZjNr9hEir8H=C5C9ZwbS7ynY4PrJuvnxa-V425A+U3Q@mail.gmail.com>
Subject: Re: [PATCH v2 01/12] mm/shmem: add `const` to lots of pointer parameters
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, david@redhat.com, axelrasmussen@google.com, 
	yuanchu@google.com, willy@infradead.org, hughd@google.com, mhocko@suse.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	vishal.moola@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 64656C0006
X-Stat-Signature: jj8rwykjna3ncjo8x1b7a5km4nxrt1ib
X-Rspam-User: 
X-HE-Tag: 1756713965-343862
X-HE-Meta: U2FsdGVkX18e4TaMzBX++TbRuUs5V8LhzDM3ez5qZ4hhrt9vfndsCrSEDjJRoNDdo7eMK/CP7Psfx6nqnI1ZhJkhIEEAiKrXNUOCwzK4zwwVEb7aSGl+dQUQ5xAwKeJNhgutOSZ9g3Dldbkh8WI4VRZ/rjQ/gMaykAdG68GbZS/OFbdVch6v43ZQ9lbXXkNXYFeo3RD23ZThxSSlogEBbbawD9UnOEa4r7bX1HlF7HMbdEKybUHKa/7mwSknOvUcnBd0IxhkWdK6Irx+1rhNfbepdQdbw4H5rLJsAe/T2rp8oJhnMYzp5kEGSx8gVF7OioKNthli2mPOv4yIqlJyXSmpRJm0UKSrbHJPv7mDEHNKJ9WCPFD37og5IGv/JvgnDPRRWNA6XRGM2IleZJbioGVXAwVrFinalTU6i27OFMce6VrmRZyfZEvWq07qaPWF2jMROTQwQhaq5v/ACyEy//S675bKHSmIZhbh8Awh24avG/0Kdinx105hAyl7aIyGnE01niysugKnG73MdTsCPqMjntN0p7I/HTQTCdzua+sD62RHYUNE8rZT+4e6xkTk22IwQ614PnvsLUKIeTRTs3OjIv4MO0/SeUKFMCOkNp6oq0Lp39/IfLlatzKaV2ezLwK0xyRBby0rFHjuoKlBW1p3ba54Bge27hAtbmiAUvNgOficZgEUVJ7hJFAgerFw/zgzDO0IlHI4c+kFzK4SaZJPskPffInqfhpvf3PTUO47hD3bXEp6rWG3GolVnDIRkSYsABS0D95CgueXI61JZJP5PTG9TOz1GahYL47bCJf/5gp6yMaXU1eNRGdywwhqStQNJHyyTsZWnrIVl3CSEtpt6Le3yRDSNQo0GJ9AdKUkT4fTAgmRDV2TeQXo0GNeuCWWlprN0Aki4hWZYRvYh8E4c/Wys0I3fN/WHRpzinVC0BLLyNRi2/ZWcePzS01zHQotMlJN11YKWH0+upO
 wIkXp94W
 ssbaPgtgvfxFbKQai5qzYQFO7/tCVQ78KJ0Y6026fCNITHWFUSccYz8j7/kvHXk+BQEOdT+YRMP6wJnKaZp9ceJKmIhOaCZ0UWgkcuNM9JecKK9VOjQGl5B98ZMyC5TefJWMIsmQrptMhLzZ2DPI9bPxybRFqAn4QjLdSGYeassPKFHWSBMVExFoOF0aGd8WkO35WONWxxh5f2AsbiYKjni6DVDG8fZ+ulgK85naPkpd49Sm/6D+1gUXdO9X94H0EgZSS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 1, 2025 at 9:33=E2=80=AFAM Kiryl Shutsemau <kirill@shutemov.nam=
e> wrote:
>
> On Sun, Aug 31, 2025 at 11:39:07AM +0200, Max Kellermann wrote:
> > For improved const-correctness.
>
> It is not a proper commit message.

I believe it is proper for something as trivial as this. I think
adding more text would just be noise, only wasting the time of people
reading it. But that is a matter of perspective: I expect every
competent C developer to know the concept of const-correctness.

Do you believe the commit message of 29cfe7556bfd ("mm: constify more
page/folio tests") is "proper"?

