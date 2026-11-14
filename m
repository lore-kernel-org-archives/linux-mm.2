Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58EED60A3835
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 20:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=Pbc/HlPC
Received: by kanga.kvack.org (Postfix)
	id 796E36B05CE; Sat, 14 Nov 2026 15:06:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 747996B05CF; Sat, 14 Nov 2026 15:06:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E92E6B05D1; Sat, 14 Nov 2026 15:06:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2E4CB6B05CE
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 15:06:02 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A48F21A0176
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:06:01 +0000 (UTC)
X-FDA: 85434805722.20.93E3B94
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	by imf08.hostedemail.com (Postfix) with ESMTP id C78A716000C
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:05:59 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b="Pbc/HlPC";
	spf=pass (imf08.hostedemail.com: domain of chris@chrisdown.name designates 209.85.215.178 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794686759;
	b=H9nxurZh4oDTa8AVOiRiqsByeR7tx2WEOd5OBMmpkahkuJL+V+Iiq+1n0FvboOgzRXhxtp
	0+iXGmx6lfg9oYtjd48ZxA4ZKryal18lbY6q7zEci2jG/TDxDCqfnEilaNQdNHl4S8zqyS
	+Eoy0Z9xLMN/JHCwcsk5jS9ayudxC8I=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b="Pbc/HlPC";
	spf=pass (imf08.hostedemail.com: domain of chris@chrisdown.name designates 209.85.215.178 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794686759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cEK0v6G1yB2cz/8630PKsjvi8Z78P9QyctaIU0ylRW4=;
	b=oMsc7tYoe98IXBoirDtnES2buQYxML32zjWtLTTkRRaPAhNUvPspM/I00vvGyBNdPCMSrd
	rWKeAmV7n3RG9dpR3eMgMFk/UToWtRF4ugkbzyM+a300xgxlTOt8Ih4fMdDHFuwaP03Rl9
	wS1rm6S8nwQf2/BAfw+PEhLaOENLBUs=
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-cd8ba7c2694so854734a12.1
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 12:05:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794686758; x=1795291558; darn=kvack.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cEK0v6G1yB2cz/8630PKsjvi8Z78P9QyctaIU0ylRW4=;
        b=Pbc/HlPC0YBLU4jBT6eX7my83oejBWMFW4E6uqd8JyiupUeqANYZvXwH10WokoqLv6
         G9Hiawn9SXCmlfCTyJ7ZvOUfTU2aLwwo8/tpsCCQEqtYtLQ+5f3FmVAUalJCv5NojbvE
         1H+z0TOcLRkaTxFxk7PSMdSiJ0Xv/8dzHuy84=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794686758; x=1795291558;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cEK0v6G1yB2cz/8630PKsjvi8Z78P9QyctaIU0ylRW4=;
        b=nGaT/w9GRuKPYdJesgfN/w0+ZDzqgDXMxdt8kePL+egcwS9hiP9owvuygtZRorJhjO
         sDsmkeygfN+DaIo8OkXoho65qDMwbdC++HGSu5nFx2Q9YbndlapzwQaPtia3/wzNaZkx
         g6ZLaFpoPA7FDh/n2U3q5YJTTDYjfWRpMsdtO+bnQjtjUj2QBGwedqK3i7MlX8nmVzZc
         M/IbBZGmu2VPzLwmi6u+mKhtLQhZTmoFDTC19/uAraKCZVruzFPErXz7lBJfNJSkulfF
         OUO9Pog/rJZe//dCyKKMAeFYaqkcb95Yyx21wGlwMUCuTbg9mr/qbsDUJUpkVP0qU698
         bRfg==
X-Forwarded-Encrypted: i=1; AL+hErF2rXQ9B7J2s0woeigoObeyeul3JOZ3ollFhebziIzp54kP032BfHOnAD5olLXmEHJrrAEE3c1mfg==@kvack.org
X-Gm-Message-State: APuU4Z8d5TmuyY2f4iltjAeFCVm2J+gzmhm/40lIG56eRwwgEYo5xeXX
	M1nvK7dL6vmdmj8YXKbr3HNDZT/6Wc7GQW7kqOg9Wjl2yT6e5UmxEJBr9k6DDo6iK28=
X-Gm-Gg: AYBFou1V9EbHZv53FWJ4/gwJA6O6LVwUWYb3TaiWO3oudyC74FDkRROd53+nj1zrPdq
	xx5/jhKBUyJrsBHyK9BPJDBT3kdogZwPglrcBxA7y8dOc0GamrCpuADChF2SpH78rNk9uF/BRPi
	PStqL6vHFNbb9g61cNP4smkce0j4tAMVRgeiQR7Ff9WuPgQaTuVaLO4JS6C95CXegOVIDJGe3lM
	tgCz34C4VljRcRVsQq4dLN5mMUFKgBfVnp/K0gOjZEe9QmuLfd8+CE1uv8cB2XJv8rIwpEMkSBv
	B9fwbX89Xc3fYAA3+O9Y4FSEjNsebESiuVO6nwHPEFNWS7bF9PVOtrFj67DwotcyO8P8iq5e9CX
	ijYBH8K6q3tpJ46jw+4I9di079t5esltv+h+cn0kNMOOTjOUUzEHYjKU90tEoyznpZN4fQlQ20/
	x0JDm/UI6EI4GBLgp9DMHhGe6PRqx8+I6CYN9H2yn3TSfz7mvjSrB1XR90SARTKhUTpqdlTVVOU
	BmA3KKkSFzLH4YEcP7Sn+7hKjgDtWtFChqZftMKX6uvMzNaBGCC9OsU2+/twzzW+c3jfjil1Hde
	BHsF4oEU1s8k7rYz4ui+0dK8YEu2sCG212EQVF7qhwsiMa0wdSRC9wV1+hBTEY0INVzM2ok1MoZ
	SI0IqYvKWlcjxtYeQPvttICFx6ezJGWHlmjHR6jYlLGHFHCfNQRaNayGbtymVleuOkR4aAyHuXZ
	9K1FhYKs0YqN3lJ+tHj2GnV6zIYZx817OfK1m3JugdgHWMgrQrqb3isgxx
X-Received: by 2002:a17:90b:3b8a:b0:3b0:9f53:e8a8 with SMTP id 98e67ed59e1d1-3b1b0b5f2c1mr6192503a91.52.1794686758572;
        Sat, 14 Nov 2026 12:05:58 -0800 (PST)
Received: from [172.22.0.2] ([64.16.22.130])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1b266d873sm4654869a91.1.2026.11.14.12.05.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 12:05:57 -0800 (PST)
Date: Sat, 14 Nov 2026 12:05:55 -0800
From: Chris Down <chris@chrisdown.name>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>,
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	driver-core@lists.linux.dev, linux-mm@kvack.org, bpf@vger.kernel.org,
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
	apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
	fuse-devel@lists.linux.dev, linux-efi@vger.kernel.org,
	xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev,
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-usb@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
	linux-erofs@lists.ozlabs.org, linux-kselftest@vger.kernel.org,
	Alexander Mikhalitsyn <alex@amutable.com>
Subject: Re: [PATCH RFC v2 17/42] securityfs: use fc_init_pseudo()
In-Reply-To: <20261114-work-loop-pseudo-v2-17-98639a2286fb@kernel.org>
References: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
	<20261114-work-loop-pseudo-v2-17-98639a2286fb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <20261114120555.cbfaf8ab8a92fb25@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C78A716000C
X-Stat-Signature: bd93wks7htr6xom1rf6zh61qu7jjuury
X-Rspam-User: 
X-HE-Tag: 1794686759-763179
X-HE-Meta: U2FsdGVkX1+jcc6lezTYpCUSGsmLH4vvSwsynJ84cS6VBL1XyEmJD7tg1JW1edBH7AOfTWYqWTdnwAF4O5HRjbdYRq8UF/w9tZq9aYPk92pySJjbdG1LGq0ambbIDFlhirre4+gnAEkcOxvR5NAytL649APU+BjiEyVhdlgQ2vWm7a4o0uiXbSvmbMHBi7x6/dwHkM6VJYqdpS5PeMAVaUxHxW7Wl4PiK6NIbJNZhsBQQZ5K9iXkFeRubUgs3WsZKEtLhcQIXo5r6ZAsAi90BlhXN7gBKPAbtBr/nDyfkdathN11sdzm4t6LbIyQGKgjqRFB5Xl29b3LDm9nby2RjC0QsEeoNDSE1Yoc49a/R8sEpOrBZe6Pflc0Az3P8edA4IziVafzmtTK7i5Q8Feq/hra/wyXc37aoB4KC/PAI9CrDQ5PbF+boWZigTDllnMuXR806wnm9xDgpq2Qyp6NiTMj/2/pR1FvOby2xRc6Xe8YpOf+1lfEl4BmzGrJIyT8B4FEcLIEvgT4+6DW9U3bHsnFWuiaEzToTtVDQMRheeucPkwS1cWyQu83p7V2l7pQasZCc9I+tF3Z80orGu+zi2Y6yxQdAZ5wsu+RybqS+6DI5k7rZteFQV7AK2IaPlZEZeZzRQMS+O0KTo9B+iu1q8C9s6+LZfXs4NMVrje3TtkzpGI/F3oWLTFVP6+gpviSho272njiazGYOg/F9vDMOlS4Y6I5soXxDKf/Ed18llQL4Qcay8OPkkAxi2mfKzbguxL5wW1N4GNl9g7Jx60Ud8LgHvF3rK8coH7T+6yBC3yFP/zG1SljPXT/d3lOs5PZgIWwfkJZtmrdHLzXAuWnnHWXW79XRJmTm8PMF9NDTsiMSv90Y+wTJvC5pCNmmbXlhybl7DIKpLu4z+wY3o22dBvWLIzLEMSDrGpuoMSUF7LD4ODazaQYjewl8B6ShFxb5G7UUY4/NQnUy3LSUd8
 FZ84wrCR
 VF4EgUj9YH9fKt7UAnJiIiRdW5y2v8uBDIGHPG5WdzZJ0AT23n7n8F9uGNNwap7Yo7A7OfyD9yeWIR8ilWuJkEo6/U9wfknt9wMqklEwzGo5Y8xlEnA7xkYrYBnQgqbeNPEpZ7lsKqm6/xO9T48/4P9nadSNzm1tDGEpWSCpXM4XsolFsERLb1uNBaGsWxyLrp4sKcttdGMLvtrSIZ6OV9ZbMNceJXmqdxbZQ47rYFks6UHUjvCZKZoNQrzLbQ8FaPUu8rcjcfzJmbzDnaQ5eJNqgEFfAzfhNSBtmUt6DxBpQTcQlaDM6WQX9fYGhfYzbFau0HUydCj7soRMEG5j421kv4i0fkjKXHvGR5l0GR8doP67eB0iWzfKtE8TXJlwmwWBpByo1YqzXgQm7lqqGqpayshzSWux/HZO1Xuu5WvZ5Af7eNOHUHDKZprKk9e4PYFQoTrqRQhdkleN0p+kMjAUswT0gSKy1t/L2odflsWRWTmtnrBWg0umhzw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Christian,

Christian Brauner writes:
>AppArmor puts a .null device node into securityfs but only ever opens
>it via dentry_open() which doesn't care about SB_I_NODEV.

Not a big deal, but userspace can see that node too, as
/sys/kernel/security/apparmor/.null. Opening it by path works in current
kernels and fails with EACCES after this patch. Now, I don't know of
anything that does that, but selinuxfs gets SB_I_NODEV cleared again in
the next patch for the same kind of node, so I think we should do the
same thing here. If not, it would be good to have a line in the
changelog saying that opening it by path is meant to stop working.

Once that's fixed, please feel free to add:

Reviewed-by: Chris Down <chris@chrisdown.name>

