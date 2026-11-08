Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1E8F606A320
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 14:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=kgEGW0Py
Received: by kanga.kvack.org (Postfix)
	id 02D756B05B6; Sun,  8 Nov 2026 09:58:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F20A26B05B7; Sun,  8 Nov 2026 09:58:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E36EE6B05B8; Sun,  8 Nov 2026 09:58:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BCEF76B05B6
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 09:58:20 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 634FD1C3CD9
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 14:58:20 +0000 (UTC)
X-FDA: 85412257560.09.FF7C19C
Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54])
	by imf12.hostedemail.com (Postfix) with ESMTP id 68EDA40003
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 14:58:18 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=kgEGW0Py;
	spf=pass (imf12.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794149898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zg9wHbUjOFQvCSSXrqJHlgr9ERwDV2A9O9zK2C7wcfk=;
	b=JVfOJLqsZa8iz35lO28ggo70/HSB2KANEdR1SMO93LqUVVXLO9pMkRzVqsj7k1858J2n8o
	L0qlDjrmmzD/UnFyTowRj/CKe9lWyi+jGEMFfxA7VtLCYzbj/sNlJGsjg1VfJD7Vszur0T
	0Td8qqhVieCNka9onOnKXjdV2vOpDAc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794149898;
	b=wqEmV3mu4IHyndfHu2xI9nMB6cKp4ygxz3h+R3wsGQAtOK+gR12oiwVohIuMFBThGoXflj
	YLkhjPCFkv88ezffTYrTZBAtrKrkp/C0Uy42cVL5Lsp0M1CzhryZZOQrcptalcA0TvoBTf
	GUje13NtK98O4R30WZbX5u9KqPXgTCc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=kgEGW0Py;
	spf=pass (imf12.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-vs1-f54.google.com with SMTP id ada2fe7eead31-7d2ccd3c7a2so35323137.0
        for <linux-mm@kvack.org>; Sun, 08 Nov 2026 06:58:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1794149897; x=1794754697; darn=kvack.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=zg9wHbUjOFQvCSSXrqJHlgr9ERwDV2A9O9zK2C7wcfk=;
        b=kgEGW0PyuZjvwOfE83tLk25W0VCPew6IYTr6IHpLD/ZSw/dDtzrf+qV9KQVxI7uzDJ
         G1IQ7QT9XbLAAI7+9JJNuGxbegznR8HYFtqZmuY3mHOrXtKmCdRGRnsw5Uenp2qkJ6Gm
         l7lbGueNKMT9YBxPQNthHqQHFjunIa7qevlnqKkbcoyiGK2B2EuRHI0dGavOS9fPh3+p
         w0cCB/W6ebwX64Uzgfe2dcxiLh+Y0kWPWo2c6JZoS6ysfpSvIuB7Jelkq1Br9lDFh3Ud
         kVBMd0p5SXP5FIaHL0usK3glBfgID4GRxuHXZUBn9YVDwBimIg/k2Fonh1642LlGbytW
         9TcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794149897; x=1794754697;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zg9wHbUjOFQvCSSXrqJHlgr9ERwDV2A9O9zK2C7wcfk=;
        b=fUB3HPJHoxM2Ja7najIwrMosGN7iSsZG1Dr7Gk7ENiTLkfxYxYyZ/wTkYdzuNHusqo
         OoF7b/y4+TuB87GCJMiFsTRq9mNbguHm05QJFwrkixVmJBIjyCFHT1isNaTkOhARzuGn
         snEEvNVQowA75dpb/1c9dvPIvDJYYF2fa6eopGE8kO3EeLSf8Z63IA2Zy7oYUU9wajNb
         ZJAqzerUu/k3DuOJ0TSQ2p8XotieppzG1TN+JTVKTnySYnTsOQIwkslLdsAodu3RVdy4
         2va+6olwK7QlORGYyighN0TBiSUbwAkjKETj82qziHxqqQQhHtzS79QQzKPZdn/4GXCH
         BbFQ==
X-Forwarded-Encrypted: i=1; AL+hErEVkhngkekHO/RW+K0nHf3W++iI3SKQ7xT1rHzQ7ID347kzbdjbyEUM3Os0Vh3Vz/taldQiPegxCw==@kvack.org
X-Gm-Message-State: APuU4Z/8UJARAwPfP5ZkxpeHJxNdmiBvkMiqCrX5oYr6mmeIjzZrqwO2
	OtnxM+nrTVjiBuIN4kfZS5TwFWQjTGRyv1VSEQ3DF5H9KfDyJ+58xXEv1YxfI/vTp+g=
X-Gm-Gg: AYBFou00cKh91v6qQTCyfX4mWLpaZRAUVnSveo+S/LW6EtWUC+G26yGpOyisrwpCSvi
	wRcu3PdJMxa0KzsXI50HN5VNl7R1nIYpu9nkrFJmT1Wi8QrX9QsWsWx3LGtquKpHvxqn6rv06Bw
	ipTBou4l63KpR37VMJ8kTKzvrNKe6Kku+7LpDZJhFhYT7mczQcPGSJpvuPg5eAoSdvuTk5txL2v
	Aqm81pcVXv6MtMLSKSyVSKVGDkS9utm7FuGdYYXtaAKG9pHhJDULUiwImVWbv2hLGnPxiT2Epm2
	3B8kVw7pUxl5WWA4FtUpSysAKM7CHPJsENVBqcHTlEilOhKYuTc0QSx5TlX+/knDAuudrhRuFnG
	0D+yDn5ZTh1H3x2/2gYBYOkgMcR8Oi/1c8jYkAaLiX7MFAXnJ4MvyXtU7tIky9ezcNhP05fZS6G
	X6qrQvlYzBVnuJLSIQV3uh6qhKQ495i8B2+UA8YG0oTSlRGA22fm19N96mO7hj1Q5GSzmmoF6mL
	elBOyu9zIUillrz16N0pwB8dKgwfHHW+XWAxaFkzJ1GY1Zi8C7mR6LjwV3aQYwhX1SIYrcf4h5A
	5PSVgfK/j/Kt2tw82nySpR6L+4uz/hYGONLbiy3eGQjuut9r1+Au8TSyVS9EYwWbE7pcmUDVRs8
	Nlav0h3+5RjK8E+zbsuG2YfPobdqL6ps=
X-Received: by 2002:a05:6102:511e:b0:7d2:cdd6:6be with SMTP id ada2fe7eead31-7d2db193714mr282127137.21.1794149897376;
        Sun, 08 Nov 2026 06:58:17 -0800 (PST)
Received: from localhost (64.167.245.35.bc.googleusercontent.com. [35.245.167.64])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-99c02a108d6sm1838855241.7.2026.11.08.06.58.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Nov 2026 06:58:16 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sun, 08 Nov 2026 09:58:14 -0500
Message-Id: <DMPX235ZQEHC.379KOADR3QVFU@soleen.com>
Cc: "Alexander Graf" <graf@amazon.com>, "Alex Williamson"
 <alex@shazbot.org>, "Bjorn Helgaas" <bhelgaas@google.com>, "Jason
 Gunthorpe" <jgg@nvidia.com>, "Jonathan Corbet" <corbet@lwn.net>, "Josh
 Hilke" <jrhilke@google.com>, "Lukas Wunner" <lukas@wunner.de>, "Mahesh J
 Salgaonkar" <mahesh@linux.ibm.com>, "Mike Rapoport" <rppt@kernel.org>,
 "Oliver O'Halloran" <oohall@gmail.com>, "Pasha Tatashin"
 <pasha.tatashin@soleen.com>, "Pratyush Yadav" <pratyush@kernel.org>, "Randy
 Dunlap" <rdunlap@infradead.org>, "Samiullah Khawaja" <skhawaja@google.com>,
 "Shuah Khan" <skhan@linuxfoundation.org>, "Vipin Sharma"
 <vipinsh@google.com>
Subject: Re: [PATCH v2 00/17] PCI: Index saved capability state by
 configuration space offset
From: "Pasha Tatashin" <pasha.tatashin@soleen.com>
To: "David Matlack" <dmatlack@google.com>, <kexec@lists.infradead.org>,
 <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-mm@kvack.org>, <linux-pci@vger.kernel.org>,
 <linuxppc-dev@lists.ozlabs.org>
X-Mailer: aerc 0.22.0-39-g5d7784875be2
References: <20261106004218.604799-1-dmatlack@google.com>
 <CALzav=dOnBUdYKN8ucD8tMF_5RuQZOzYG2aW=K9Grd5itgvnMw@mail.gmail.com>
In-Reply-To: <CALzav=dOnBUdYKN8ucD8tMF_5RuQZOzYG2aW=K9Grd5itgvnMw@mail.gmail.com>
X-Rspamd-Server: rspam06
X-Stat-Signature: usw5hdmdih4fwhcn57n9mpqf6i3wmokm
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 68EDA40003
X-Rspam-User: 
X-HE-Tag: 1794149898-593371
X-HE-Meta: U2FsdGVkX18/cYO9hIDb6wLSL+ob+/AegYTOj+WIG5cstCt/M9rJzFM1rkjTKgYzVFOkUDtO70oIEqX9ZobVOEQsBWP+JJSJC9or078dJEX8yoDES2KnHiqbnDYbJFFjfLA6ziLCjUqaDtdflCjYZu3his8N+j+v9VjMh6Wkdf9BhJPlYT4tgp7aJdFJL27XkFNit1rAzOFd1CNt4Mr3yv0FwICBsgPnRD+z7cfq51zIQ7EgZ5Oh7QoSMXLj55v3CLdEuVq5Vv+0VqWfArOL3zP/DVUv6EoyFr2ddk5cIUG3BK5T2DRIFSLAciwNVg59B/rh08MhuRLltoIwP4ssjXuGEmnncLKJSij58KAg7BF7KGppODIIT7J4OxNkJLKKTl01quNa3fz/ZadeQpzPcJaT7agXiWv/JV/AKp7MihWyLlIgt3yvkQCcmNb2QF/ffO4ii1Lp7I//jfozvck9cCg+NR5ouQ70oDwoUt5znJHxoMDTA6rY8x8G6zlASK4vrxnAwg1uaBSB6K5paHsjkizQmsTGoLeaGXbn4WnoBZRlQHp1fnIh4fgNIhwMttrkbZV3AoQ3KtHwV/IC1hdmmhGyo04OIBhnirr6odgrW6lSbEcDFm9zC+VmDZVWycTEr+1cVy0/P8ngXH30d5U2/xiI77C2IHMTlBoCIJphyx4l3u02seY+0OQi1YXuiFBSsEkDuxlSkXiCZnXrPgcj1HtilADCvqVi4Pudy+xQZa8Ikc3zwTFrAdM0uptz16g9NfHJ6bx5v+PJbd011Fbykvg0A7f5RKKdvSye/M6iXFGYK+OSyQkkK50++dpHb/Om2nafrGfs3KiL70zse89FxyR9nxIFthe/eUkMWnKOkYv1LvKPMXsKa/Znr+zmCLp/WdT5f3ShfDcguKerFj/auMrsD1ZaYDnM+Lq+JAFyyHuu46zPy7nMbUdhGn0ZwfskPv00Nq5q7h2UjBA1xCS
 UD8ARGXH
 SobWMKaMQi///sNWxeYa+div6YivTLS1k0eYjxuuAnPZ+pe8nL6ZyVyzmyStrREtAD9GuLMcqYhn/bE4OkfcpQc8Qb5mx/fWbUPWwB+PoDHAbdya9jMjF7ImrCLvtQMvO+KhhgQaDbCpOC3e4U7nSZAx/GQYxKgh6t0IoWj3hqGl3fay8LBxQqEC7SL/1EfvgxjIKwbyqkdQBqUCB6y06twzOtB52Ydv2+12U4jGvSh8sIkOdaarICxJAMi9UXe2+963IX9CsF3i238/0m4wE0vIKqV0is+bnUWDF4cx7LDYBVhlA4UJ8WTVOZdJNpGR52RjFsJ8fatLOZDWRtgJHK7t+20khubWRrs9YpXYaVGbwMHLWDTjCbdqshB4OFJy8ZfJE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu Nov 5, 2026 at 7:46 PM EST, David Matlack wrote:
> On Thu, Nov 5, 2026 at 4:42=E2=80=AFPM David Matlack <dmatlack@google.com=
> wrote:
>
>> Merge Plan
>> ----------
>>
>> This series applies on top of v10 of the PCI core support for Live
>> Update series [2], which is targeting Linux 7.5. This series is
>> targeting Linux 7.5 as well.
>>
>> Both series will be merged through liveupdate.git, matching the
>> agreed-upon tree in the MAINTAINERS entry for PCI LIVE UPDATE.
>
> Apologies, an update I made here got lost. The PCI core support for
> Live Update is targeting 7.5, via liveupdate.git. _This_ series should
> probably target 7.6. I doubt we can get reviews in time for 7.5. And
> as for which tree, I am not sure. This series is mostly PCI core
> changes, so I lean towards merging through the PCI tree. Only the last
> commit touches drivers/pci/liveupdate.c.

I looked through this series. Even though it is motivated by Live=20
Update, it is primarily a refactoring of how the PCI core saves and=20
restores capability state (to make struct pci_saved_state compatible=20
with Live Update), so it should go through the PCI tree rather than=20
liveupdate.git. Only two patches (12 and 17) touch=20
drivers/pci/liveupdate.c, and we can Ack those.

Let's get the current v10 PCI core LU series landed in first; after=20
that, this series can apply against 7.X-rc1 so the PCI tree can cleanly=20
pick it up.

--=20
Pasha


