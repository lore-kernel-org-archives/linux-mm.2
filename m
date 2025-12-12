Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94AF2D4336E
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 05:15:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D15CE6B0007; Fri, 12 Dec 2025 00:15:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEBFB6B0008; Fri, 12 Dec 2025 00:15:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDAC96B000A; Fri, 12 Dec 2025 00:15:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AB3566B0007
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 00:15:53 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2895C1A0422
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 05:15:53 +0000 (UTC)
X-FDA: 84209656986.12.CEAF882
Received: from mail-yx1-f50.google.com (mail-yx1-f50.google.com [74.125.224.50])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5C35DC0003
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 05:15:51 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=OSxl1ESn;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of hughd@google.com designates 74.125.224.50 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765516551; a=rsa-sha256;
	cv=none;
	b=Kbm0fYBhVLV7miiiWTtJmKL2ugbisQnAppo1EM9SujGzcaJMrE0OaIpg808cgWhwKwEhda
	86bE9nhr5TPyE0OYxL4SEDWa42Y8bM6xHDQIf71jY6+VeZXBms3PUcILNoUOsSRXeH+1ha
	ZTjDXBWBJPUMRT59pUpWhahIkLqN3Hw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=OSxl1ESn;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of hughd@google.com designates 74.125.224.50 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765516551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KPFmcLhqBnBTcaIEv2PJZuGjTwqiV4AuTcMDvkQwEyw=;
	b=ztXLXVUPgOGAwC0eZML2PeGkjhovQ3dRR58ibKtcfml/PDQI24GJWONmSuqwVgI72Lyv0C
	sb0Qv8+5uXU21yObb5/VmqZsGReu+6VN7q+ytgknE6iN1PLPg4GCGoZ1bxf099lA220zz7
	KtnsNL5JVy36rpjJV+kUVwOsXlG2mKM=
Received: by mail-yx1-f50.google.com with SMTP id 956f58d0204a3-6442e2dd8bbso1002348d50.0
        for <linux-mm@kvack.org>; Thu, 11 Dec 2025 21:15:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765516550; x=1766121350; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KPFmcLhqBnBTcaIEv2PJZuGjTwqiV4AuTcMDvkQwEyw=;
        b=OSxl1ESnZNHLBIYXayJjv3yeG9JyGgEGIXbT6KiMqgPCFFVnFkWtM3xJHGU+XKS2Fh
         fZ+VvKfXQYE3BzScYfJXgbZlv2cxGBvfhT9W6Rw8awGWcUHFNmnisZe6Sz+Mz25DUSLO
         G35WN8Ueoj5XvHEIEzLhB1ZKG1Ewza5z+IvfcadT4vIg4X7wTYR+HqYjRzgLO1+4iZkD
         WLxY1CQBMCLpgUgsA77CTMSvRyGzoGCv2FOPaPuyDG3MR+4lHbUAdJAsgQC/wKgksIzi
         ovzjAdPADTIHoExgv0C9JYr+3oaa6Ihnk6cC8i6qVSTtuC2J+YIfmnfAiqodGxoe/VdC
         j/7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765516550; x=1766121350;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KPFmcLhqBnBTcaIEv2PJZuGjTwqiV4AuTcMDvkQwEyw=;
        b=GDWYWVhqkWhXovW+5PxwmMOks2vRHOtNM6mEETU8hFJyT98GlcbTLK7/p0xG/NrNQo
         PB8l1sJkZ58Mvy56ASpH83KrCgEJNXGrpdQN3WKf4p7niHmw/r3A9p2dN1I1O0At5D+G
         Ol0uRh8dE9ohbbongZoD6F6F9z3YU9HNdw5b0SOijZ+Mlz2cZwZ8Y6ivXUqN2sNUQS0b
         MRVTTqyIHahfvDZhvPbjgVjQ45rtzlHxJjUOsMtJF2oNyjgU5Xp+MrMhgvrCcoG/OxZv
         P/cj/4hM6sHW6J0dQqlgGHzU8nqijVOU9qvi/53P9u8x2FFNEKiXTfSG6asl+6ugGevS
         2Z3Q==
X-Forwarded-Encrypted: i=1; AJvYcCWs7LWGKXc8ufFHo30hSySnivQSF5c5scpw7kB6Uu4R2nD6Upo4CF0pE0Fh9T3OgEczpszkUyxseA==@kvack.org
X-Gm-Message-State: AOJu0YxBKLk6zCgtS9nz3IgzN3CTHQs+iCFuISRCvhWXsuvwSkYZhrnC
	xHeJD7IW6sFBPiSxaP11fHFtUFmsAKJaIE9ucvqdYRxcDe/PeNsBqlD+/G6MMZnP9w==
X-Gm-Gg: AY/fxX4wZO5wtcA/BgmJ73Dt57mjlcS4E/eoNX+pAoNCIRRKXCwexCXw/COuX5wESOk
	3CPK0euMphLCPqr/HOP5MVrH2YPqOBTFsZZbfEwdiIwHg1HZslOy5eBlxRn0Kgh2KNvrpKeg7zz
	QOqt5EwTVzsKYl8Z2qaY4jUgC+HmL51gN5ZMiVicc/DfAsIkQ4bssMrpy5TgcN0k6CoOHaOCtBL
	6e1oOt61AEK2m2RXZpTbVdCPYC83Nb9KxGgImY0vNwFzZ84iw6JikcQHPDTBSq0OaRpCTmvFQEP
	BRETnT6r6XebEC4oum/qB+z5Dd3jn7L+ytiqi/viySn6fE9HSMfX3zdM/cjx70KiaCYSYsr4d5r
	1o9NZLeJkbBrsbMf2Pocpvr2NP8sYmJ1x4Yz6/ubQEX3O8s+5R1tkcStJMgnAYgqbvibyml1kjW
	xItIdKzBgwFr2+rtXiLxtbYa9tfE/yj+vk1j+G2Vwi6DxnuASg/ek2lU4KRiqoPfErXAuvtd7dg
	3/PtEjmtQ==
X-Google-Smtp-Source: AGHT+IGj4VXQERBjFBx4z8QJxqfKFrAr0raivKj93bfeYMOpD2/ljOQYzi5YzTwvUjTi4XXcYyBnYQ==
X-Received: by 2002:a53:cc0f:0:b0:640:db91:33c4 with SMTP id 956f58d0204a3-645555d245cmr503152d50.18.1765516550148;
        Thu, 11 Dec 2025 21:15:50 -0800 (PST)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78e6a2161bcsm1378637b3.25.2025.12.11.21.15.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Dec 2025 21:15:49 -0800 (PST)
Date: Thu, 11 Dec 2025 21:15:37 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
To: Al Viro <viro@zeniv.linux.org.uk>
cc: Hugh Dickins <hughd@google.com>, Christian Brauner <brauner@kernel.org>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, linux-fsdevel@vger.kernel.org, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: 6.19 tmpfs __d_lookup() lockup
In-Reply-To: <20251212050225.GD1712166@ZenIV>
Message-ID: <7f288332-5514-e2ed-69e2-50c5e0304d92@google.com>
References: <47e9d03c-7a50-2c7d-247d-36f95a5329ed@google.com> <20251212050225.GD1712166@ZenIV>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: 5C35DC0003
X-Rspamd-Server: rspam03
X-Stat-Signature: 7cmodik48pcgunits9xmohcothm15197
X-Rspam-User: 
X-HE-Tag: 1765516551-650829
X-HE-Meta: U2FsdGVkX1+HMGTj0PpTgeSA4Hw1USe5Vu+cPxRknVZy0+y93VnTVRgaRMMC990g2mrVZhOE8zKedOz+hzaDcpgXMvm2yljPMEpApDuB3g9m5OoEhN4j9maMXYoWdsqyaH+3nWivbjFFOba71pcSK1vQvVKjDohs4XqQj9dlaCDsQXlTKbj7tPgZgWy6MI0/lO0dF3QX8WJ/cY5Mio8yx+U/zaDe7zEZgoFqa9DdnoRLjsG6U2olsYKoRk21Fc2Gr+PQRK5dVK9S4/Wdy3fqE2Ncb5tzc4ArFPWwtQ8Csv95jnQytGt6vLFBCEVptiV+1hr8qqHrEDG7770jDEpO89W0hLZG5iW+TVAfuDLFNKkyn5kY6rYtnVgWPKEKGUt3Y5YYCF5LxCICvsF+SQLlBXxeiIEAP1GQL3CGGi6z9g0BAakUwYFG4qgJQCGKkekdjbA02gOS7kCa24mxK8nrLE33OabUGi/0ToAxOfxEjeTylgs9094vkxSeeIJF9/+ZIcnSrZEHryovzuhs7tMZASqESwIAAGudS0qbC46rBMJgJuwhU2sglm+azGOOts6WqgoywPJOipygHy676l4r1VJN49INb7ncZafEItM0ioWhTHinWpWQY1NcOx03BnmMwe+o5WwlRbv/SS/WrvtE4RS2btIWgWzT/Hy3idrkW2HPvdE6WVurHxo6VCbQkCOQaVmWBMyPlNtIuj3MpXC8o3bkFcbMNLNYI0UxGEtcUnOh3eJ6DWei79ob+I60xYr6Zdt6gVXioyrVz7JE/kPokNBJfkgFBmObnlmsxwyOC9GKWS7H1/8IJEIrdnb7gk5WamlMG360FO3d0Sn4/wSUPXk3MLgRq3faLkPv0bIAJNQ5922x+B75JSHiSxKeokJhMDaoPSRkRS4XGm1kObyPkttgAY9fOjUlPtLlktIO5gzvnlo7P7X34+Lc7kDst3mO40Yn83gMDXhRcBZg+uX
 T0+cfqrg
 rTSKFBPzV8+ady3Y6jiAfUfmAE+0FCXN99CRNf3oWouFuvRO0V2JqE0a+hum7asqJhYO6KYu1mPdIOPibpBwD0e28ukKSZ0rk10Fu7yX9g/BYRJiigM5ysRd2fsQ99MvWIkqg6Nj4QCX560thjr9WX5OYZrl78hkfxj7lmnKn4NZskWYz4x54wuJF5pOCP4JQMBxlQVXigrzwcPGNt/VJhNRe3yJurGKowefg5WRo3+g9ezUB7iOkAoHL+zO8huVD3HkA5RCWcAWQshicH7Yej//eCoNJVu9yvyfbRV/v3ncdlrDKlNBYlQNRew4q1EwvLf9PZp5XnhAnMDkzg4La8z8TvsWY5uCEPDec+O+q/IgBuCxJ3bfd8YxHQ7M/nP24J2QL6JfGv0qtvmc2zJKOeGB1gw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 12 Dec 2025, Al Viro wrote:
> On Thu, Dec 11, 2025 at 07:56:38PM -0800, Hugh Dickins wrote:
> 
> > Of course, 2313598222f9 ("convert ramfs and tmpfs") (of Feb 26 2024!)
> > comes out as the first failing commit, no surprise there.
> > 
> > I did try inserting a BUG_ON(node == node->next) on line 2438 of
> > fs/dcache.c, just after __d_lookup's hlist_bl_for_each_entry_rcu(),
> > and that BUG was immediately hit (but, for all I know, perhaps that's
> > an unreliable asserition, perhaps it's acceptable for a race to result
> > in a momentary node == node->next there).
> 
> Hmm...  Could you check if we are somehow hitting d_in_lookup(dentry)
> in d_make_persistent()?

Am I being stupid and misunderstanding you? I haven't tried
running with any printks, it seems obvious from the source that
d_make_persistent() always calls __d_instantiate(), which has a
WARN_ON(d_in_lookup(dentry)) at the start.

But I didn't see that warning fire on any occasion.

Hugh

