Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C001CC6B12
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 15:17:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25F356B00C5; Tue, 13 Oct 2026 11:17:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20F806B00C6; Tue, 13 Oct 2026 11:17:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D8116B00C7; Tue, 13 Oct 2026 11:17:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D8B466B00C5
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:17:08 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5C39AC0C3E
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:17:08 +0000 (UTC)
X-FDA: 85317956136.07.BBD99BD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 836491A0004
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:17:06 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iibnrfTR;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791904626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FS0+hVaAs1leiq/YTrMeyQe/03tIpKfjtoNv7HK1mBc=;
	b=7UyNN3t77XZhvce2qim4noDp/mXCkl0YkTHYq1cyQoKnOr483DPWot8r6H3xg4KfLLwEsm
	mD5SW5HkUhp5QyDHkDi8MFehIZ3aqilrX7NVqBkFsakV8OG6gu15JsKRlBVCNYbXkmKa4O
	aOJ6It5n/sFLCFphq/1S3O89YOBZAng=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iibnrfTR;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791904626;
	b=4mjCK9QjKQeIUSvq9hbPAR5yKSuuHryLBX94kBgLZrNeXyC4qO8qx2YgGFxEanm1HKHzsH
	tbM5Ms1ZCPXeVO1da/+6Gm/JevYibp3dyYG/ATmzIxyYsc8lA3BbC5BitTKnNzFRTsILn7
	PFM90ybFJf5hC1X/Qbz95c3lZQXgc9w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BEEB64089C;
	Tue, 13 Oct 2026 15:17:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 834FD1F00893;
	Tue, 13 Oct 2026 15:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791904625;
	bh=FS0+hVaAs1leiq/YTrMeyQe/03tIpKfjtoNv7HK1mBc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=iibnrfTRgId/HSv8NGAIWzkVXt0M+QgU6ki93Fl+1MsM9iumr0D7YPWQRosECMtuT
	 43Lc01ci6ifVs6GKljeO4OfChmKOCA7KxZEGTzCWsIpYXX7PNfs0ff7Uf2oYnxsVaF
	 rQ1Cl21vi6GHx72+cRZQJ8chk7nK02H1fMmutx2XIXfhN4vESypf1ueV2rUMQbP7IK
	 unK137QJewwACWG9pqkRmEcPNcuvyYkNTMK31E+Pjm7LSTIJT+EsAPWPk+VqgzdS2s
	 K/bo6+wYJUz6T8Mxf1jq5TqvRiOMuaIKitHs63G63K2AD2+zcyIORFh38oS3Z+uajN
	 LfT4byun/OrAA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 13 Oct 2026 16:05:01 +0100
Subject: [PATCH v6 21/39] mm/gup: error out early on !VMA_MAYREAD_BIT VMAs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-21-1aa3c9b139f9@kernel.org>
References: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
In-Reply-To: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
 Paul Moore <paul@paul-moore.com>, 
 Stephen Smalley <stephen.smalley.work@gmail.com>, 
 Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
 Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Doug Gilbert <dgilbert@interlog.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <mkp@kernel.org>, Simona Vetter <simona@ffwll.ch>, 
 Helge Deller <deller@gmx.de>, Sebastian Reichel <sre@kernel.org>, 
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 David Airlie <airlied@gmail.com>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Arnd Bergmann <arnd@arndb.de>, 
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, Anup Patel <anup@brainfault.org>, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Janosch Frank <frankja@linux.ibm.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 "David S. Miller" <davem@davemloft.net>, 
 Andreas Larsson <andreas@gaisler.com>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Youngjun Park <youngjun.park@lge.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Michal Hocko <mhocko@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, 
 Xu Xin <xu.xin@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-usb@vger.kernel.org, 
 linux-rdma@vger.kernel.org, selinux@vger.kernel.org, 
 linux-sound@vger.kernel.org, bpf@vger.kernel.org, 
 linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-trace-kernel@vger.kernel.org, 
 linux-perf-users@vger.kernel.org, linux-arch@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
 linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, 
 fuse-devel@lists.linux.dev, Ihor Solodrai <ihor.solodrai@linux.dev>, 
 Bert Karwatzki <spasswolf@web.de>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1431; i=ljs@kernel.org;
 h=from:subject:message-id; bh=0md27Wyz/h5BdZQhHemsaPOn7ZTCaX/gxM29oSjEsUg=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLOeZySXqetzeuxf/1j2853HCai9x52m02XuWR77Uofz
 7v9f53udJSyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAizfsZGd6feMqTOO/U6e2P
 PkbEXD5/qHxW/P613P7PnXuLTwZv6v3D8D+8+eDCC+asFQeuKVncEp5+ftJOjj3F9dvbbvLvZtD
 1d2cHAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 836491A0004
X-Rspam-User: 
X-Stat-Signature: skhfknd5gum5qno8oodkub8qryy7i893
X-HE-Tag: 1791904626-992024
X-HE-Meta: U2FsdGVkX19QNAOPKitNDJAPORFxIH1vuGHmuKklCvwEGWyMp0lPFMT1JCyiEz9cv+YkVPBJelhhI1U0LuX8Au/08svJXb/IFzk+7nm9VhkdXjRxufTeMEPyajKn18W3FqnXtZ2kdgs5+TNZn+CKzTziy04T0xd0gOvXIrGvO8YXhew22nerr6StYVP//b8tRr2e0mWn4ND+EtpciAsETT+nHWR4rS986aC0xpvMI+HTJEadSlkxil5YETfuNJ2LJ8yW4vAUSjFcD/jKqHqjp9U+2hxaBLTW79YkGB3mO7FKg0fel1AsSUOIqbEse9s/TBnATVqxqQFk06ukRsbc3jIpd5DAon9JJhWmh90h6ZkMsPaY/fKELYP6CMsMLI2eRksQtH6THlNGcXWf1fKQ0MMKCwCQSAtuYwhZ1T/Ao1X66F47VK2A22wg9fQKc/JDb51I/KuMZeIJonNc4e0H9G4tJVqowr4z+u5qUfk1ynREXgDsEk6YY1KsNhHfTvb2/RNG5wtNgvuhrM72amcmWmnjGvXhzDzsWb6AK0ZMuza3j5aNWn8MlSVFB6iaGlh9oOKph3e/30u2SywNyHqWjHApDKa+OBVIdQ/zQa5EroVWAJL3hEUJkVdLg/zcaX+hliGqcXv/1PhTkgZc8FoHA1H3zln5P/PRRSSchfAbLfjWBWwf8fxV8cnjHASrHZRB9Snvdw1w28JpUHs1XFFuETqZCdPraURjx1b27HRcbpbs+ZIR+4Vi+SsqwzwYGUO/VcXyanChPSvmxRxH5zL2T4v7cNeOzucehb/mfcikh3e6tB249kKTPXrsXuPdDwv++HG41NWJ58q92ZzmfsSEjZtG4Be18OSsVMAKtn30aQH55mQrsMpFk4WoVUEIy8o+HZQFOM+OPqwGbwJ5l/xNkT8209m1qnqo/2SRK2Kl6Raa+6BvnAaEyEYrNpTqMskRqZzEcTp/7FalIemqc8X
 DHXjFFp+
 KWfF9LBJ3uJPaOA8MqWafyhqhXp2+Y/r5KGuIwLCPEpYOcKrY8RXJp/1ND5nIPNQSCJZuCAJJvaoNvLymLbgYenHKpEcl2XsfZXmJhWutdXtY19AtUxlDE1Z673HfiaPdWX+qIdn1PAMOtAv5FxhC9oseyzrVDxGBty0cRPx6+XklO2hki8KS9pE5esORhGhXRNMnDFIeush1CPzwIbolPsl8Hvn4qaPvNZVmbPc4C7yZMZsXlibGH/HqnUhWXEXiuB+nKuqzpZmXJ0oSUtW2uHi5Q4+561Zg/u3mh7imDJidGKg8YJYpkdXjpZ3Y10wJd+gO5H7ehcS8K829QaqsDH6GClqSOl25tRwJKQBk2Hlcwm4yZFUzTZvQdzfwrRfW4eUFMOkNQeZTbOQDUKK7FNURrGdWvnQjAf5kverbK2QZj/JeoX+ctCtIyXZw+k4iFkqarxLXvSVseO2y7xT7+KOyKg7i9ARrkuoo9+dLcKBBAxWSO6k0cbd43MosbZOTuXf10M8eiVXCu9O1CYkp3KzMlqMf/n2ZDl6+SewfGqNoKoYwiXQsM+NQk/7+qEOlrwGxG5tiaOiEQB+QufNXxwK93W/tdN5MhiCwHLPhX4evDCGYU6k1FxjAMW5EQrovDzX9vw4BN2138ONjNs6XGayEpOi1hMEbDIndy1lhhFtk8++sIzy86OSMgp0r/fj27j9bHC9XmYez1I0rI4XpW9SMwBjRIX0iNRw995bI1UKMBa6DsIjJzKciJkArd5VDga1GzRN++xIxZj1rWirpN/VDo6UeUfIxlqqYoy6xZm5Nubeqy6PCF3uiaDxMcwm929vpkOnYza2yHOUqJPIoCdvQu6UUfpTFEXcSiAo6zo8dvImSwVUG2sPGFKn7auOC1q/IDkyVSTZYJP/g4NB7yCnxmZcQy7NIfTIxa4psVOA9VxTgkk9YKWdo28Pazp+4n1DaL97jJcf8CnR92QDOEk/Cz4kO
 4I2B1G1F
 +fTmG4wpGHjGwpX6KVlx8U4o9tMgBcfI6PLOxzVt7x52P4EZArBFYye3I4eVKkstkMt8142gqmJIBj4NFAIdedoYXC3l9vaeKDrenVr8H8bN+JSzwJFk+UCmv0+qPko7YDdR5BYE2hjDr7c8utHbnRNCO2cPRqHdPytmhGv6im3UXcQh7SL/rfTaI79VheDT4+PHwbvVG5ZMcGWhy2xyn3/mQq6ej5aLMo/WR9URKx+RMjlarPdknZCWGdCRYPZT57P/sHP2twT3hR3qtWQ+O/GJyssAWST3dhATKfRl3uuBlW9bTyAbL8Do73UII5Wc8NYWoXIrHX4BsMC5seQuGWPNP0ZnuJZ52a83KP6ZbRENYuYm7qBT6bTdtEy3FIuwZPyX3wniCn12VSuUAGtG6OQGldUIPHth7Uee60txE0UZEtYpNbLVr6kF34VvtUT9NyeqEobrFJ8oDKzFTTZF5kLj2J8FWu2s22az+Xf7Oh4uoCiGiw6GCId4v27VrfYerKNBA9pIO1sbk82DyzsfSKVnHCQ4/1aTobQMD0OlQGzAkb9LXGXZQ9PwIAKRFqV4I5FF5z0OsAs8R9OPsEexDIj6ddimDhO1d3UwSpbEa++mbsgRQPefpcr03QFdvVJfx8uDTTOcka8ALP0RmkjbP48Afug/hlCqVbMZCvJ0dPFmT/2kcVnhbYoLeH9CptJR1ZYOUAvxZgzD22Y3HuDBNSN97t3vTXeBBgQBjdqAUvDubL+qrw2rPE/EZd9QB84rZ9cl4dkOF0567uBhDp+auB2DPHVci4op7Hh1J6jAKxDFtmXi43Qw4qaxH7NoPH+dYtcYFrNaPRuOvR7m7Pk6XcaBT0cbavKU+KoimK5+9y8jdwOAu8PZAaG8Sy1B2VgmSnmqZyuiEtpOZLKsWFigrHutzsb90b625K96OE49gY2WOyRaujBegOzYWVw4prrqQ8BPgJNSaDn2Xd1uL/+bIqCzCcXEp
 dBdE+7ai
 xi9cLxlWiXWFZ4tQ+/AswPkv9KvPtoCFn1CKWJxmT4EyIs9qvQyzeZwSUa2q3hllGFlDyysiCguGiQM2hDHuzIXqvnlFtaVye+x12WX22orJAauS9smeyADcV+pyYwcrCabfaShhUH21uebD08Es3yNrtdJQmKLtRpP3LY6OBpdIgdms/ErChX1PG24p+rgzfcErgMX/7pmDUYczNAzOK9jmVNn2H8FDN++ZcNVbGcAwShFZqpPWNPdjA0UXZIwm3omKPi8D8gjunXdzBJgK3LJb2IO+hYBC8JEi7gLe3r/vAAnU8FkDYh1XPJSKsHIvLUkfUXtuR4bXpQ5uRmtAEi3HAA1iMJ/qttpI5aeT3D/gM2+RAq3md+nhQgVT8A+gTr2F6XEumWcTCBW/e9QilCBv8iw8qWWMCdlmLtXKn59AQtN2kPCaZ/jg3yldLv0YmcGWvkVSIPeFTdM1oSghZWKGmFMN395GW2P0aTTNkCm/vFgtmQU7b6vSDB6lucihHoX7dVNYDI+9u1wnZVdYcOfAZ/8bTbbAaPY+CRPzA0PfVby7rHu5CSKsYnSXrDPwPPvqtEEXjmGia2k5OIhT/kCkNgtdL6HwB0dY50aWbq2GZB6f8A1kyxrZaAmrOMuUOQ8f5Y85rb/9mEf8op3Da5gR0TzRRvpwVSFGCNRj6k2kNKQ8Ss0lhE6pFKyYpJR3TxzFiRrnh3NeOcWbgO4aWgF4F7P5vA2lLWYQ6ewDQbXe/qAQXvkVw4H6kAYU6pkIjLFOKlqNA+osyXpa4tKI1RshGTocBbGI1UJWyRWOTSw2A8hteVIchEVaRKuSxfpRtowqvmixBiwV0/dxGMAuzNAMv7k0Q6lQyWDBsJvMCjrBErRxocwTG17y6EkOaRoLGgWqOBzT22NL3FdmjIg4h2efvLG0yM4N8tR/9io+dtjcCUTUwew6t+GAmrMBKEMDUncpgy16nZ1Aw+kxT+zmnm8JfMww0
 GhJdR9PU
 Shdxf3p9JCIB+8ni/NDVuDforUeVmoFIbnGi7yHwMWFhujqtOX3NuwLyqhn9XI9jZExtfHoiHBdMeFd78AJ1wITxE/5wkRKlNBqGcpxXbn2SPisLstJuAD0cGmAvlmomtxU0IfSa5WagpfxH4Ht6Vp5vrBsviUdqISixkzMZmA2pt1mQvKf8FqzP2pVN6ZtpWEVscGKAZFRY3GfPObNjAfMrmpXrlH1INkH3x02q4sqIeVjud2ED/BJAIu4YIQE0E7YDKH6SuMbRHNY2gR4uOzVyFqcSYUxEms+K+LR47wUhuegxt7hI0vo9IRJXqXTqPtSyVGMRF4vE7TriEH41gudtHxjcIpcu+U4Ce4k5qoBs2lC6aCAUALt082UyzzG3OVXvEYgoUJ1G8yTCMsTn9dOpUZ7ZCdlHGHwHmbmhIPgFRbAz+PEB9e
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When populating a VMA range via the aptly named populate_vma_page_range()
an unreadable VMA will always eventually fail with -EFAULT.

That a VMA is accessible is always checked, however VMA_MAYREAD_BIT is not.

All user mappings always have VMA_MAYREAD_BIT set, so this check only
impacts kernel mappings.

It is implemented specifically to disallow population of uprobes XOL
mappings which are exec-only.

A nasty interaction with these mappings may occur if they are mlocked, so
actively disallow this early.

This allows a subsequent commit to remove the VM_IO check in
__mm_populate() which otherwise requires non-MMIO mappings to be wrongly
flagged simply as a workaround.

Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/gup.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/gup.c b/mm/gup.c
index c2dfcb4744bc..e6310a7cc05b 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1836,6 +1836,10 @@ long populate_vma_page_range(struct vm_area_struct *vma,
 	if (!vma_is_accessible(vma))
 		return -EFAULT;
 
+	/* Unreadable VMAs also cannot be faulted in. */
+	if (!vma_test(vma, VMA_MAYREAD_BIT))
+		return -EFAULT;
+
 	gup_flags = FOLL_TOUCH;
 	/*
 	 * We want to touch writable mappings with a write fault in order

-- 
2.55.0


