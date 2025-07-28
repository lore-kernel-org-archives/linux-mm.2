Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A99CCC87FC9
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 12:54:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34B596B008A; Mon, 28 Jul 2025 08:54:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3221E6B008C; Mon, 28 Jul 2025 08:54:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 237906B0092; Mon, 28 Jul 2025 08:54:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 153E46B008A
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 08:54:08 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 844CFC01C9
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 12:54:07 +0000 (UTC)
X-FDA: 83713666134.30.CCE3DFE
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf04.hostedemail.com (Postfix) with ESMTP id 71B0B4000E
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 12:54:05 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=fFkzL8RO;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf04.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753707245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AFe49a4vrehhtu11WrBTtnSIZQtct5R2DgXZ+umFAog=;
	b=zTM4EDTpV0jp8nKtzI16Z0cKhnk4bK4NhAiU+L1SvJtBUwPzX1Xu7aCoxsKGsk4P4jUjOu
	dftnLCD1SKVpIyfb917IsysfpsvMddliWIQYtVBiDVTrip3E86s1iPc+ZqpIt4nH3tKE2A
	g7iFhwWS3JkNCEQiv0RByZccLeq1u10=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753707245; a=rsa-sha256;
	cv=none;
	b=0ie9c/bDAzMZpas4w3kT7FewgUYz9TWyh7mkvUSrZV+ldDZ6T3vuPbPbhtBSLo/+HXahpJ
	e3WZq+MtDE4P6eAO1VaSlCII86W9VNC2J/0Wty7kgQuslwD8ry71XZjlb1fzeWRmvK4SeZ
	2ap3TEHsV+tDdWOdrwuFD2a2fDDHMRs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=fFkzL8RO;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf04.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=mhocko@suse.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-af66f444488so54389266b.0
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 05:54:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1753707244; x=1754312044; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AFe49a4vrehhtu11WrBTtnSIZQtct5R2DgXZ+umFAog=;
        b=fFkzL8RO5OkqOkigG/4ch3Tl2xcshbr21Msq/9BgOD/KbiEUaYVFZKpi4k3dY7jeBM
         qT/+sMtaivFYfk18w3WYSoGd/JhBQKMLVhWJWSRX2eAm32PvkzPSfIMVYcJs00tZQ5XZ
         SeY+owffVSvnP3jO+ZFTA55uhaOUuELqdP8wExbrmfDxAhQ6AhN+Kw944cYzziULqRyM
         s0SDb5/eLfxqBMcK27SoJ2KV9sj2qFf7vukgWjNv/YT1Hh7g9mo7hC7yDPQPTuH2obSC
         7hjWAndsWcx2HgYawSxV8d716YUzD36lNeQOUy3wHh7gThzwcD0nU7zFyemUuSb7NzxL
         8QKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753707244; x=1754312044;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AFe49a4vrehhtu11WrBTtnSIZQtct5R2DgXZ+umFAog=;
        b=ZrXPSzHlUXYQiPFWG8mDiKi6XOgtlWrUP7ZOcsUSIyI3t6IK8hQlxh9ic7oEVU4HLk
         63eFhrwpdnKChBEP+KwR9gmwm8Z8MliHvuLFAB3OY5iso2sLyNrmeRa0anJX+fUyUr5J
         6uWa0Ln+vCY4kYhN4uBAVhm+8kZTGucEWy97chCjxyS95JlUuaw7qDayWSHmINKX6Y07
         /dTAGBm3ef296k2goqWV3zJbvcfMu/dKC+WS27pKv/pVgEuYCn3gtYiy8qDGHh8y3noq
         RllyLXu0PnU8G61q/0diSJ814HszheV+QF0zsTxsEvTGZ1XPJwsxeULnq8AHVnl1aq7Z
         CloA==
X-Forwarded-Encrypted: i=1; AJvYcCUHKgOGs6+LcUZ2poBjRyMV813bztlnZ5bKLkQ8vCscswCwFYVmzWfaEpfUIVH9viSqkxKZG2r8lg==@kvack.org
X-Gm-Message-State: AOJu0YxYtUnD07CgNKdJ12+YyQc01PW3t7Qv6vkBELwTCUKdjqoFhh2k
	Pt/lYt7BbhQLBy2ZBqW06YlIPSJqjIBJc48pimUsa5Pmk53JODCmi/uh5PVoCMpT8yc=
X-Gm-Gg: ASbGnctCV69xLFGVarXh5MdSsQJ2amT2oKUAQbaxrEAKkUwr2suUOt3oqdNnh+Tup6a
	P6hsISOUaOQzDPBTGIx9HVqXxIrdBTbPDrBPCmoSHPzBf3WOLV64Jpom2RZ1y5V/O7VWtxCW1CD
	5WtvifcJWCGsGsI22rYX5KokoLfbNeYZE9EZP4Oe4aatV3jmoQnGnMaEqmzHgFPhpVoAhcPBNoW
	8fVZwAdsRkA713BoiozmLL+EyntSVLiWExvxtIDCSDk+1Xk/mqZV28w3SrB9ZOocjBxFF+rmN9J
	QdF3YHCDSsBdI7VmOV4lfY/kpIy+a/m3CK7pNY8Rcd3aX5qGaBd6aVMfGc25XPoJVhS4pKZaQUJ
	SJ0HL1976u5NxLiqbAlAJPHhmy8mBY7afPp0=
X-Google-Smtp-Source: AGHT+IFFThKk1ZreCJF9jzTixRdz4e//89EMTAFaSoI7nWzzvHCr57vBuWSmLUpBCNfSVWSCdtgoLA==
X-Received: by 2002:a17:906:9fc8:b0:ade:405:9e38 with SMTP id a640c23a62f3a-af61c8a54a2mr1094958966b.24.1753707243632;
        Mon, 28 Jul 2025 05:54:03 -0700 (PDT)
Received: from localhost (109-81-20-172.rct.o2.cz. [109.81.20.172])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-af635b42027sm422277066b.143.2025.07.28.05.54.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 05:54:03 -0700 (PDT)
Date: Mon, 28 Jul 2025 14:54:02 +0200
From: Michal Hocko <mhocko@suse.com>
To: David Hildenbrand <david@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Hannes Reinecke <hare@kernel.org>
Subject: Re: [RFC] Disable auto_movable_ratio for selfhosted memmap
Message-ID: <aIdy6tzlrZhrXw3t@tiehlicka>
References: <aIcxs2nk3RNWWbD6@localhost.localdomain>
 <aIc5XxgkbAwF6wqE@tiehlicka>
 <2f24e725-cddb-41c5-ba87-783930efb2aa@redhat.com>
 <aIc9DQ1PwsbiOQwc@tiehlicka>
 <79919ace-9cd2-4600-9615-6dc26ba19e19@redhat.com>
 <aIdqVNCY-XMNICng@tiehlicka>
 <1f8d924d-3554-43a6-a75e-66a08d1ce7b9@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1f8d924d-3554-43a6-a75e-66a08d1ce7b9@redhat.com>
X-Rspamd-Queue-Id: 71B0B4000E
X-Stat-Signature: 4u5n5a1cgju6qp113jx4761btp7pidjf
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753707245-737287
X-HE-Meta: U2FsdGVkX1+ntSBis6sqHUnZwSsu1JNAwe8O21wWAjkuKRCvDMWVTovhv5KEKgL9r2EkxA+SR0onuwo17mdpor/URDtYDDZuHHNzRCo0E3DNHc/iIPGn7VLwrTUbO6swNF2SU2u6jyBrJNtRkfVsdDUbP+MC/FNVlDMCEEk21z8iwiD9eVhPWnkx19wKLOJacoZ4nYWKQennDdSec4DM4j6TObB2ro5hRehJ8h7qEatuR6bbFGew7bzvYP73ntRLe4aXYwFi8KWShGyB0qvlElqrCBDHDdtmntFmiv+/+l7B+1zwjtVnP/eGnJuxfj/d8N7fc4bKd10YSOeIc9j7zP1RHSoEgbpCk4RDs2/rU1g5WwEffmk6TbRE7AYbrp6FPYYyTTzV2xsHCln8WMN46pXmZ9+Ogcj/30BFY8fUvbQBzqS70djIui/5U5yYvTPj3YwGhsutPjzkLavrzN/HgatcnqdZLi2xKJ/qdQRQNXHGNHtm83mL82ZjXvXjh/9tqnIEpC6wvUeFKvvZ7uxUoW+iVb3xz4Gxlms0Qx1DjpoiCDyvrHr7IfMPwqLVyzIQCI7Q85OIpJMPB+gkLfI2k1UHugmI2ZEaIK7/m/0+HyoSa/N4rn32pBnjT1e1fIiyO9TIUnAn5HTL/O8XK6CGNZ++8dgfUTKuvkaI1d/AZM6LU51tzrH1k3MsAdyJ0LCgbeCmvxuBVceVDvCMZg9x3Ct3CEWCA+bKrimbaMN8e9YGyqm2TF3TiGFVLXTwvZtFwGHXxMPp762S8ksSWJMR6RNMhb2VUSjFqDvUTgA4Y65kp3yFUD0YBRf6wjdc5U2qW9sW5asM2WX7J17oD+O1Lb0EZVT0FUS+YlnJmnTgIAxCGYq65t2RCTPks3idwQsbrVLXSk7XDtb/WXKPSl1aoKw/ZTh03iaqhnaf0/3A56Lgena6gRhiO/FOsPYOioy6rgDIAQf2FRm3rNpZwg1
 TYuXWpVL
 KAQoXye0KmQAlVQiZIXgx0z5+fxl7aNZOdcWQfRRHXhDfybasD2Ari3t+79QZiB+EkyHOVFDUB/qPAsLjaYQS+FW+HpPMQqUut6UK6+xM7R+cbbKGrq+aekc6l6N78q4t4qqs6wz44/ueAN5lrkmihWS8sSuzbdHqsAXi+AhUJAIg7AccpUDJC3j++ZXKGJMyzy6Cg/fbyML6WkgyVcvvzywQOgdFc2LKMK9ctuLpMbppDXGKjAly469uD9eh+wPXmHdI8MoQ7i+EXiXzMysNFdN+qONFbGc+x959J5blq1a5PMRrPgP3NqCZ4zJudCeg00gRiSTc0AZ5u7JYv2YSA2yvG39cObWLHo+f77JOX2ydxtM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 28-07-25 14:27:01, David Hildenbrand wrote:
> On 28.07.25 14:17, Michal Hocko wrote:
[...]
> > In other words what would break if we didn't expose CXL memory through
> > memory blocks in sysfs?
> 
> I think the whole libdaxctl handling for onlining memory is based on that.

I am not familiar with libdaxctl so bear with me. What exactly from the
existing sysfs interface does it need?
-- 
Michal Hocko
SUSE Labs

