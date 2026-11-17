Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA7E5606A32C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 21:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=K95kdnrD
Received: by kanga.kvack.org (Postfix)
	id 21BA76B05B3; Tue, 17 Nov 2026 16:16:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A4E86B05B4; Tue, 17 Nov 2026 16:16:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06CD66B05B5; Tue, 17 Nov 2026 16:16:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AA8D36B05B3
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:16:27 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 15CC6A7F2D
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:16:27 +0000 (UTC)
X-FDA: 85445869614.05.E21A0FB
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3D0C0120005
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:16:25 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=K95kdnrD;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794950185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ays1EfzTLcRjTY+4yI71x15YxEo2laYpKiSTCWHUOoo=;
	b=qiHmqlwgr3ua1kPnDLlVdXheG0W8ps3u1GJ8JMUSYAodTPYW4FYvu+GDUN94IBE+GRGlVN
	DXzwSDuOXLjHC8yhv9zGls90hWjkBIrvl5olC1MVKhbh7gMCVT3lsU4C/JTNQ8AScdf0NS
	Z/EGcUf1FgDz2bJ+At+Lo7sH9YgSSnU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=K95kdnrD;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794950185;
	b=yHo4fMDmDJZDfNwPoSllUkdqydfwLaoH2atN2iG68NRLYd0qmo3ILFQKpt+KwiadF5+DqM
	UGNH2erphNAiewKdnvaesjdXPm+30ZS7kvILDHuDSronZtw1yU+rz/Dfuuc9CFxB9OhueT
	0yJQSHZv7ZCHeqw/NvhPDhp2FgahT8w=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2ee1b65fdbcso1109845ad.1
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:16:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794950184; x=1795554984; darn=kvack.org;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Ays1EfzTLcRjTY+4yI71x15YxEo2laYpKiSTCWHUOoo=;
        b=K95kdnrDF5RwDbT5KsvjxSDZg8fdal49dP0PxCzKAz5UktEcBBV4UTDpdVhiNBan9z
         fNzcS7he66E060dhl0Qy9t1VjEOghWldgU/suvqGrmNITVX0DtHy+ZXUhFyv3wrdk6Ay
         QTJmqbEs2UQzal5mbSHo0upq2qXnM+6AT+Pu5d3m6ihEw9bv4FLUsZF/usb9os2WXA8f
         7rbe92XBT4/1bTgNfMKHQXe8DpDqERKEwnjRG/Vy7nZVJDqmk1DOlyhEdNoss96bpIAT
         rqFxlTwS0ki46qCp4d34f3Ia7Vdp4QGE/+tZ9MaWTGcv9BuRd8NyWsWrkBA5OzDkyvaY
         Amig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794950184; x=1795554984;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ays1EfzTLcRjTY+4yI71x15YxEo2laYpKiSTCWHUOoo=;
        b=jQKQ4gI9rmDJ0CwGO+hQsg4nL+aOCNH8ZRJFA0mzEVb8ssfs+r6GnTIbidksnv/N0w
         rHjMincjhEIJ/4q9ZJoEXQMJivAB6vxCanx6H3yeQzsbxlrsWpQz53VjV2W9LuPsFEBR
         oYchK0YuCfINrmrco98kBNXn8yyyhfY3n/LqVCu9i8VUghtbLgOcy1iBILyiNua2A2i/
         gQYNH9N2XPVxmXpeiOn4PbEo6mdXZSIwd3pU1zvIJbHtwzVhIhYIoXCAdW8/CySgsItr
         vA1mk2SpyU67KteKFaKtLcvW0Ct2ebrXDGIgHHhvZUgzbMhcx+A3Ax3BaTG6nw0KkOPb
         IhLA==
X-Forwarded-Encrypted: i=1; AL+hErHRc6hGKCkKDXTVbSVu2ub3xwwkSDDI14ZEWqhDsnymu43T5V5TFuiuq9HqbZnBlA54CfO5uEDHFg==@kvack.org
X-Gm-Message-State: APuU4Z9MMMBUdoESjL6WLyu7kmEygjHnOZN87F3QichUTrfNc4BgKuDc
	RrY6kFbfNj9C4/Xp2gY/XXqzRi98wrFDzht49awcNTsB8axKEBvK5zpEgGUcnqzhWw==
X-Gm-Gg: AZFdTZccTjInSpujJMjKMDz08mT8TsWZLJkVPdcfJwn1jjQp7BxUP2SA8/dNoTnTlA0
	dpm8mrQ3b7mQID6qVbf45/Mmqh74DiBHaMa8LpB6RnBWe880aj4s201EggBoLDF140VWKtZX141
	c8+XXHo6TPQXxeO7d07MPsL/bv1zwcuoLxaKwtaQJV4ZagXcZJTgghsk8CStP18rXQ4BcNQFtSu
	OFQs4g7wwCGBW4Yv0d1c75i4w2haGs4JjZLyxOzjYEAVk8X6Kd1IkXR5wX5ZGpRPEMi5qYkXvZR
	Pn3pm4cjL2xbF0OUZma4jNVhzyU2WzZG3Msu1hX8tNEZnotIEquES5QLzno9EmPs+xJ/eAcBQVL
	lQthq4rC/Xrm4e0jJ+2uh/6E/q2qDP76sjfmFL/wDTrgvTTZXGdGyBsRDRQkY/vmp3y3VZjwZ/X
	RfYc6LiJxl362fvDcg7Z4JBUwqGocq5C7anRKRfkGOtvrilVtpAOrFJ57Hymibldgb5Bvdm/8ma
	6GTG1BqfUX/Gw12YEhOR0B+xpxN+L6nI3HCtG30mrcOufYPVKxqxM7psH+06AiTbVRXtDha0DCy
	lJYZQiNi+QqidfbQbTfcktc1I5hPC8QA+eBg8T4oEsWQr2XLAnGbtxFhKIJA2hq09Dno4y6SnFH
	Al8o7GBH1IA==
X-Received: by 2002:a17:902:f790:b0:2e9:460e:ca57 with SMTP id d9443c01a7336-2eff7529757mr5030915ad.15.1794950183338;
        Tue, 17 Nov 2026 13:16:23 -0800 (PST)
Received: from localhost (33.79.127.34.bc.googleusercontent.com. [34.127.79.33])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eff61841aasm2714705ad.34.2026.11.17.13.16.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Nov 2026 13:16:22 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 17 Nov 2026 13:16:21 -0800
Message-Id: <DMXSQHZG5L27.2NIIT7F6FW0ME@google.com>
To: "Alex Williamson" <alex@shazbot.org>, "David Matlack"
 <dmatlack@google.com>
Cc: <kexec@lists.infradead.org>, <linux-doc@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-pci@vger.kernel.org>, "Adithya Jayachandran"
 <ajayachandra@nvidia.com>, "Alexander Graf" <graf@amazon.com>, "Bjorn
 Helgaas" <bhelgaas@google.com>, "Chris Li" <chrisl@kernel.org>, "David
 Rientjes" <rientjes@google.com>, "Jacob Pan"
 <jacob.pan@linux.microsoft.com>, "Jason Gunthorpe" <jgg@nvidia.com>,
 "Jonathan Corbet" <corbet@lwn.net>, "Josh Hilke" <jrhilke@google.com>,
 "Leon Romanovsky" <leonro@nvidia.com>, "Lukas Wunner" <lukas@wunner.de>,
 "Mike Rapoport" <rppt@kernel.org>, "Parav Pandit" <parav@nvidia.com>,
 "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Pranjal Shrivastava"
 <praan@google.com>, "Pratyush Yadav" <pratyush@kernel.org>, "Randy Dunlap"
 <rdunlap@infradead.org>, "Saeed Mahameed" <saeedm@nvidia.com>, "Samiullah
 Khawaja" <skhawaja@google.com>, "Shuah Khan" <skhan@linuxfoundation.org>,
 "Vipin Sharma" <vipinsh@google.com>, "William Tu" <witu@nvidia.com>, "Yi
 Liu" <yi.l.liu@intel.com>
Subject: Re: [PATCH v10 09/13] PCI: liveupdate: Adopt ACS controls in
 incoming preserved devices
From: "David Matlack" <dmatlack@google.com>
X-Mailer: aerc 0.21.0
References: <20261013162529.1928093-1-dmatlack@google.com>
 <20261013162529.1928093-10-dmatlack@google.com>
 <20261116170942.720b06fd@shazbot.org>
In-Reply-To: <20261116170942.720b06fd@shazbot.org>
X-Rspamd-Queue-Id: 3D0C0120005
X-Rspam-User: 
X-Stat-Signature: rgyzp6cgosj8waxsc3b71j1k5bf8ndiq
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1794950185-159326
X-HE-Meta: U2FsdGVkX19Whr/EFkMaTVX9b/Bvcw4gX8JB8fIWQcFBhoTxTEH/b4Hkd4F5eZPx+oDuDovG2ZReBuUFqe3MsFCAdYx50Ou+LlImRGm3luh/mxQpae4E7bIUeDJTyRdTWYlRx8NlJObWX7rFGcppOT1rflbwRS/eH9RiiI1kUWRDqi/CQKMsUnZc1grnGjsHz34Yy+E9WJzUMdTVVobay8cyRn5Y5ewNHpJsNqGWCbA0swJS+7X5AgaVbzu8s7JbuCwa6sDWNV4KHSxS4Rrn/KlQIQtLzF86EWrfFq9up8HMsrmqCxiaC+U0Y94tpTL5rn4sEW/sLSzDfj/jmAnqFKb8hlfiVD8d1uR7nrAe6gDDd73WbI7ve8gbz6/q27prfsQBI57k3RArNkX6q1p8T90K4vGz49GTjHy0L6iG6h3T3WVu+b8n+UgRel/vBPztGyPQyOhXZd6JoQNuGRtudKPmpMM7fqiYZy8JlYql4UEIL9oaws0xrjRVMQ2VZozQBhBbCEAqQ8RNxARPT+ye754qwXg5Ort6F9GZpk5ibluolG7tLg2NQ8LQUYHzKOnSS/DY/Tqm+agE08DdJRYGcvCYQjgpyyAJfO/eralgr1/rHdBFaLwAAhtlt64+XLIs96x1BzkOlH0r9u2Nw3TW0/YahyWboAgBZrHxTgi+SUinT1XkQrpCxJJ25q4q6Hi4l9I3IsPI6w+lKFX7ol1OkzJDn/Qu5NJMOqDz+Ul+3e6HDZLKCATgkmJgYVQqKhPZHBkbV9zxiQ4EMwWXbbPVh6h643Q2/gqJA9wnSPwcPDlfjuWPs7O7NvvpOzrip2QgtLEXhcjc+eSgQiehiuyg01e12HZdei+ZMzu3qf6TuErlhPnaBu6zD6G0o3vTpLguohD++JX9UR1jadO/Ic6E4iJ5IZyp+yBfZssEbbvR9vLDD60KpVoYEA9PaCmfZC2wk65sOssrjZXir9aYfl4
 yN/2gM8q
 OZ2q7PKAFlkMj2tZuW6wIF96aKKqkbLI+EssfD8ZSBXghZZjCo8nmTse3qmPjarpXusnW6xuIer9O6JKepq22EJ25vbQCvZ11UPLHPuhTSmjJjzonYhWfCuntmbD/mC5bJ5YRCFL/CBN9JBnaQTd2EFEOrhW+osifgeSFziBbjJg3bpOkMlZGoiYqRvPnnVSM36odGU50cvgN6VJ3LPjGt6veb9NCe/85I7yEqXPHy52OkBigOz7u5pyCoZ9yE9sNW8hAH+d0lj930Lo/ooV0iQxFSSkUSwmx1r+Yy2EV/Geh500lBIwpQMKlxpCfzuYRnh2mh2RjHeaLMb48L0hF4IbAJBIS0z/kSRqu1ad4PYaLnbgXfms7Om5KLI1GwV8lkmvBn8VTAGpgZ5EJfa2ujbW7zvNGAwTnsEvB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon Nov 16, 2026 at 5:09 PM PST, Alex Williamson wrote:
> On Tue, 13 Oct 2026 16:25:25 +0000
> David Matlack <dmatlack@google.com> wrote:
>> +int pci_liveupdate_adopt_acs(struct pci_dev *dev)
>> +{
>> +	/*
>> +	 * Check if the device was preserved over a previous Live Update (even
>> +	 * if it has already gone through pci_liveupdate_finish()). This ensur=
es
>> +	 * that the device continues to use the ACS controls established by th=
e
>> +	 * previous kernel.
>> +	 */
>> +	if (!dev->liveupdate.was_incoming)
>> +		return -EINVAL;
>> +
>> +	/*
>> +	 * The previous kernel should not have preserved any devices that
>> +	 * require device-specific quirks to enable ACS, but if such a device =
is
>> +	 * detected (e.g. new device-specific ACS quirk in the current kernel)=
,
>> +	 * log a big warning and fall back to the normal enable ACS path.
>> +	 */
>> +	if (pci_need_dev_specific_enable_acs(dev)) {
>> +		pci_warn(dev, "Device-specific quirk required to enable ACS!\n");
>> +		WARN_ON_ONCE(true);
>> +		return -EINVAL;
>> +	}
>
> This looks pretty unsafe and the comment is only explaining how we
> might get here, not why we shouldn't panic.  IIUC, the IOMMU lho
> support requires singleton groups, but I'm not sure what it does if a
> group becomes non-singleton in the new kernel (such as via a new quirk).
>
> Is a warning related to what might be a parent bridge rather than the
> endpoint device, really sufficient here?  Thanks,

It's not necessarily safe. The new quirk could change how TLPs are being
routed while a downstream preserved device is still sending memory
transactions.

I think a better approach would be for a preserved device to always
adopt the ACS controls left by the previous kernel, and keep them
across resets through the ACS save state. So a new device-specific quirk
for the device is ignored, apart from logging a warning. IOW, new ACS
quirks only take effect on cold boot.

If a preserved device has an ACS capability but no save state (i.e. the
allocation failed), then we can panic, since its adopted controls would
be lost by the first reset..

Roughly:

	int pci_liveupdate_adopt_acs(struct pci_dev *dev)
	{
		if (!dev->liveupdate.was_incoming)
			return -EINVAL;

		if (pci_need_dev_specific_enable_acs(dev))
			pci_warn(dev, "Ignoring ACS quirk, adopting ACS controls from previous k=
ernel\n");

		if (dev->acs_cap && !pci_find_saved_ext_cap(dev, PCI_EXT_CAP_ID_ACS))
			panic("%s: No ACS save state for preserved device\n",
			      pci_name(dev));

		return 0;
	}

The panic would only happen if allocating the save state fails. Ideally
I'd like save state allocation failures to cause the whole device setup
to fail. That's something I'm hoping to do in the future on top of the
pci_save_state rework [1], and then we can remove this panic. Until
then, the panic is constrained to Live Update, and the allocation
shouldn't fail in practice.

As for IOMMU groups: Sami's IOMMU Live Update series refuses to let any
device join a group that contains a preserved device, in both the
outgoing and incoming kernel (__iommu_probe_device() fails with -EBUSY)
[2][3]. So if the new kernel considers the path less isolated than the
previous kernel did, e.g. because of a new quirk, the group grows and
the IOMMU core refuses the second device rather than putting both in
one group. The system comes up with that device unavailable, which can
be debugged and recovered by rebooting, instead of panicking.

[1] https://lore.kernel.org/linux-pci/20261106004218.604799-1-dmatlack@goog=
le.com/
[2] https://lore.kernel.org/linux-iommu/20261110040828.1774343-6-skhawaja@g=
oogle.com/
[3] https://lore.kernel.org/linux-iommu/20261110040828.1774343-13-skhawaja@=
google.com/

Does that sound reasonable?

