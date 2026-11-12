Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F046D606A890
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 17:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=Q7gwyroj
Received: by kanga.kvack.org (Postfix)
	id D3C556B05B1; Thu, 12 Nov 2026 12:12:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D14486B05B4; Thu, 12 Nov 2026 12:12:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C03066B05B5; Thu, 12 Nov 2026 12:12:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8DDFF6B05B1
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:12:36 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 166054062D
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 17:12:36 +0000 (UTC)
X-FDA: 85427111112.15.1541D8D
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf27.hostedemail.com (Postfix) with ESMTP id D753F4000E
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 17:12:33 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=Q7gwyroj;
	spf=pass (imf27.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.47 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794503554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F6YTYLTty4ZhMoj9B/ri1dVEfYoUCO5Spihz/O49FOQ=;
	b=qsFLPoEyBNTJN7aIsdn6KXJtOCJM/Sus56dRojePu+e/XwkxxfqfZ+EsM1ubLJV7xM3eRS
	H5exOUM/nVQhGbv+lo77ip3ozAyjFcfvcmVeFGcyH598qVyh91KBYbrdL8dS6rDlo5qzZ4
	+/bdcvb/DN0C9AjfK7f5GeenkMb6Uko=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794503554;
	b=WEd7N1XFF+0wyK3j3J5G7lcqzrU1d3+lo2Av4LURy8WxxdTFAAYMW/BTnLCKHEZJg41FtF
	jWt4Anzi/FqV2H8Hw+6t9jAWiTsgwNeNFh9UbsByikTOptt+4jAdInjHKe4iDTYCeell3M
	lUx8IPxmkt4A+IeE672LApdKdiwxkVg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=Q7gwyroj;
	spf=pass (imf27.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.47 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6b5973a4b4cso27377a12.2
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:12:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1794503552; x=1795108352; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=F6YTYLTty4ZhMoj9B/ri1dVEfYoUCO5Spihz/O49FOQ=;
        b=Q7gwyroj16T22SpRXbyKpck+UXzByockA8Pv61iFKPBY8TkDDe6EZ2F18Zrp9s3TRE
         rSb7NZrsw7pSfxuI2VN+yW/z37ZF7ft5ajeJBCQ9EH2Tmj78IRxvB7XGC5uUT4gmEQ7b
         E3n6JMt3PR/arLluwWwkS85xwNb+HNcbi53sc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794503552; x=1795108352;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=F6YTYLTty4ZhMoj9B/ri1dVEfYoUCO5Spihz/O49FOQ=;
        b=vHb7HWW7/uk58/Bu/IujLU8TMNkpapKbRTfbol2bm42fUiAtRCySlxxZT9jZmhvvg3
         rkkM69jErD4NfVccI8Ve34wmzMS1AzAnxOettPR0flMsQYxGb0Ho4RIFS2pEGoSnq/rE
         0CeTc7iSUo9o4vS51rAiFRhG8wJXE4z8nJXU42LAxU54IIGfAQfj1+QOZH0ygxO/xBN0
         emp4oVT8+jyx3mtw4kbrVzXIDMY96m4j2y2IgaAb6VvFACotig188pCSAojVUdmzYc9f
         NvFRdTbw9PNqmOPF89JeOHHjBJvqW268cg3+6NZ4PAhfzNqMxuK+qG3JCyWhEyLDozB5
         CMBQ==
X-Forwarded-Encrypted: i=1; AL+hErF6i+wNEa4TgDiHQFL9JnCNKgevX/4gRq0A3XIZNO0emwf8hyApp9dU8NaIWwwNg1dthMVRdyWIYQ==@kvack.org
X-Gm-Message-State: APuU4Z8ONN6lJ8ehZTIG2s7CcdG4BpXzTPPabbqKOvajC96xmX5pPTVN
	jUqlwHL13eu72GxEDffDxVVBnxrfVRzeLLKzWR9jCfUwsyIr2G0YB9lX8albCRejV/Wv6BX9QRt
	wA5hfmQMYMA==
X-Gm-Gg: AYBFou1W0AyVlobvI5xzVM/c0S57gOS5X3Xs8uMrZLX3KgwkYPSXtoSDBNfYXYBN3H4
	9AoBoGTE/l7ozvKYQ4jw8lKGCewJav6DiECh84VRS1TRS3iTA2svM3MZcZYDt6OerLxZCA/BRBN
	y/zZbtEKCjNAinMCAMng5xtBiNOW04icQuaVY8hQEGbv8efmlukSBwJMe8T884+f/2xPNlSGfrC
	+pUzXP9ADVmoExSFdbmXETmkpLZPAVpBl9OMaz18wimefMTtDXn8V+nN7WqKX4dmWXWzomSgxxl
	DFsviISlAETVdsCjYbYIyH1Br3xwI3z97itXZZtXrRhIHUd1NhlndSligm6buHcxCOiUwg1AkAa
	0fo1qq3+GypXFJzjwwHmM2qBvMGQwHmlOTf7CORqYronc9QGetfxkEfEnmOH7UVE1cPIq5zEWqC
	Jv+qlsFGapfoELIF5XBTjhJCK0FZUUNWap7B/RRsxynTruVB3Plhr76xFUXi/KFAM2OCuh72clH
	e13mcFHbMoPwv2oGzx6W4Oc1B+iV5uybhZJ3Rv5wNqLVQ8wZRr2A81z5ERby0Nu1FqDsC95YZkP
	/+tKbl/6qKx/p5wB8oUrg8nKotixEgrIiHHqWI+kcTEDz/NIkk7qDNvN/ZO5yKF6Vc3UL9rP+fv
	5jio=
X-Received: by 2002:a05:6402:14d0:b0:6b6:e857:19d4 with SMTP id 4fb4d7f45d1cf-6b7c0bbc8ffmr214335a12.11.1794503552144;
        Thu, 12 Nov 2026 09:12:32 -0800 (PST)
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com. [209.85.218.48])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b79e58d3c9sm1103578a12.14.2026.11.12.09.12.30
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Nov 2026 09:12:31 -0800 (PST)
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c3f04e0e65fso682695966b.2
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:12:30 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErHxVOv9k7VzuiZ5jUCF6ZvaZbPVMz85wUy3vzuR93SjqJWfyoQN4E/oJr1fM5ilAf6nBWbwlD2rNw==@kvack.org
X-Received: by 2002:a17:907:dab:b0:c35:babe:ab44 with SMTP id
 a640c23a62f3a-c50665538e0mr626078766b.0.1794503550222; Thu, 12 Nov 2026
 09:12:30 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261110145241.536019-1-kas@kernel.org> <20261110145241.536019-2-kas@kernel.org>
 <avNuQqLf9CG9dSsE@casper.infradead.org> <20261111-heimreisen-ungeziefer-empfunden-a892571f2c07@brauner>
 <20261111-thunfisch-wirbt-waldrand-822275b2d3b1@brauner> <CAHk-=wjPY=kfgnmtx4COEQjD5UzKx9m2-=KLGAZP4d=RKEH+pg@mail.gmail.com>
 <20261111-stumpf-montag-miterleben-c4e2feac8090@brauner> <CAHk-=wjGXBnme-N+HvbzHH40ftb7Suc=kZVT5cuintQWyMHJ7Q@mail.gmail.com>
 <e94bdf7c-eae6-4f64-bf93-0aeedca1a22e@app.fastmail.com> <32ad880e-5946-4703-9c6f-43ff59da39af@kernel.org>
 <3eb60948-8fc9-4682-87c2-c113e54e7d4e@app.fastmail.com> <4d6a3d68-3fc7-446e-9f59-f61d7475e22e@kernel.org>
 <bf186643-780c-40e0-bde6-f2af90404a18@app.fastmail.com> <b90d4bcb-b865-4a41-8496-78d751c03dfb@app.fastmail.com>
In-Reply-To: <b90d4bcb-b865-4a41-8496-78d751c03dfb@app.fastmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 12 Nov 2026 09:12:13 -0800
X-Gmail-Original-Message-ID: <CAHk-=whTG_hWYC=a2+uu_+SeN4E1ra0n=ytGqyk83Yr7tDuEJA@mail.gmail.com>
X-Gm-Features: AclHuK8_5teM8idFuSWqym8O4N3OQPYF_Y6jfMJ_yh9uCx25qjwD1XBnjE0OwRA
Message-ID: <CAHk-=whTG_hWYC=a2+uu_+SeN4E1ra0n=ytGqyk83Yr7tDuEJA@mail.gmail.com>
Subject: Re: [PATCH 1/4] virtio_console: copy pipe buffers in splice_write()
To: Arnd Bergmann <arnd@arndb.de>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>, Christian Brauner <brauner@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, "Kirill A. Shutemov" <kas@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Miklos Szeredi <miklos@szeredi.hu>, Amit Shah <amit@kernel.org>, 
	Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>, Bernd Schubert <bschubert@ddn.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev, 
	virtualization@lists.linux.dev, Netdev <netdev@vger.kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	Malin Jonsson <malin.jonsson@est.tech>, Richard Weinberger <richard@nod.at>, 
	Geert Uytterhoeven <geert+renesas@glider.be>, Nishanth Menon <nm@ti.com>, Frank Li <frank.li@nxp.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D753F4000E
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: aoyg9g8kw7zx4osyed56fm53rbk1ooa5
X-Rspam-User: 
X-HE-Tag: 1794503553-889465
X-HE-Meta: U2FsdGVkX1/3fmG0wGd2AdmWDhpqMOoIaiirkq8l9JUS7X2lMDOoDCo30RA8pALCrrwXDCQUfE1+lbX1Z0cVKfM4P0q7rIIAMknrtUYmrCmBZpW5jLJ6igxSTHK+bnmRSyrK2sj/88KYI26dNQPkYK0Jd6/TP/ZL8dupdfMy0JYwe0HHAxx9Ilm0yTBflBr4vOIts2N7jXCTsJxh+ZQNE2ruU/Ix4AzkvCSR/s8q7cGcaqOy8ldEQQM13NYT50Db0tLVxC1QAZvZhlFHEsvEk14BHObhpOOXs8cyn4TnOGks9H2UXhWkOXQTWaRyT/utEt8noLZVvKll/3OzX1wNycOMQYK9c2UMK/3oTLwOREYC4prOwgu2sBS3H40a50yv7B+jvthnXDprfZxr2snwtcJO+lyLftIuvwDuqa/BW0BtszswRfRqPglnkw/GM7je3Le0Pr+jbLnOiE+7xj1IgiMgo5WyiYil85dCfn5s3y8e5xbD18SfjM03GnoxN1+8ylco3ayHursED02SoYfgE2Wiz22iChR+oAp1UW1iYlMcfJtwjJg+W5fk1UuhTEHg/vsij6Q8sgSz7gtnjXkr6Dl17Dqf9eXZduRQBAJPwCqcmnvdqwakCLCsoP3wWqId6yiW4GgtH4mQ/OmnHfalF5Bd26Wz9d0QwZDbaRty62hkUCZ+tDQnJq/NUTMvQeKLV8fR0Cv0SwmN1PDe3hReYt4Wcp6sssrB4/BgWyZENB2z+dl6jT1fh6aCArVJW5jFwRMHdQNQLCUgzWs/HoxEbAGKK2IcCz07MHwYiE68v63McSJfwZUpplXnEggSuG5QrVLsXMU2EL2C77UPpnTrLKnyzyIY0OxBNJPDBTqy5/LBQn7XOWNoaI5sy84SeMV9KHn0g8W3iRZ8f3xQr/FbSYQhN0Uwc5CXYoKEHUu2TvGC0gxKQhSrBFAnhRknhOHQiBIEQLKK8P7nCyugEoe
 WDActr89
 nf8NrJLBcucHkrk0CppOmlXDS0y8vy/FyUQduxz07bkZgk8MDPpu7btxjw2LBBEnlL0X1gkvZDVbsM6XUdPBzdFluvBrA2a7QKWMNn+Ab0zqy7+KlJ3aELRzjTd9bnyDnpU43SfQwkBoDwv7iYFWmwyTAbePkYU7xU77fhTdcJWUHyW6Kb2u+8IdUWTUvyG2tcv6LWpzFXBS6D7cfuWofqe9oqXgrJD//8b3rygflhyNU1q7O7eGXE9LXFltFP1ayoAMAhW6Fcn/7G5Co0WQCSrvGQQ0LcbwOo/rusRhTufp9HrlgbQh7qc76C7JzTJX3l61fzsr6XGf21u+UOxaJ8eohpegLqX26xtiyOpXZzTZTBQnZZVzLLqUDhrIhXfOmTHS9VM8wt4ZJXemFkKaijpykytlw04Y+VDvLQDepGIajwNx7JB6JCINR15YLiXdrq+bIyFCFtvw7gmJ7estuSVLMUesu9EZCmD2sd6oefe1GuFFNCBxSzIjQO0eg2dwvFhWzaS85nQ4ju6yXhgzTPZjAs9r5ABo5/KHAbUuG1rK7/UzRbxmNHr2raS3gSBQf816J0wTqgBC0Rh2n5qXHppGFpKCLvkTnRiYy8oOgQFXKXXdl5drFJMoo1nNMOQI/rVmYHC5uaDexleUGBnEkpSwEhoHNed2uufxLDmpnLBKNgSVaS7XfctlbH9CezaahBibE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 12 Nov 2026 at 03:35, Arnd Bergmann <arnd@arndb.de> wrote:
>
> Posted with a somewhat shorter Cc list at
> https://lore.kernel.org/linux-arm-kernel/20261112112528.1116405-1-arnd@kernel.org/T/#t

Lovely.

I'd love to expand on this kind of early removal: anybody want to get
brownie points by just removing the remaining users of the legacy
'kmap()' interface entirely?

I don't think we actually have that many of them. Almost all users
have already been converted to 'kmap_local_page()' and friends.

If we got rid of the legacy kmap() case, I think that would get rid of
the whole "pkmap_page_table[]" mess and the PKMAP_BASE / PKMAP_END /
PKMAP_ADDR games and only use the FIXMAP area.

                   Linus

