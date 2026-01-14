Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA91FD31A03
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 02:06:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D2C86B008C; Tue, 13 Jan 2026 21:06:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49DB06B0092; Tue, 13 Jan 2026 21:06:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C0FD6B0093; Tue, 13 Jan 2026 21:06:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2F95E6B008C
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 21:06:30 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CDE251A032A
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 02:06:29 +0000 (UTC)
X-FDA: 84328930098.02.EF823D9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 00CE6160006
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 02:06:27 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OOEIRwd0;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf08.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768356388; a=rsa-sha256;
	cv=none;
	b=kjclTXRuVEQrqXuy0g9rp2F0K8oOPqDsH9HYJI2S/4M7my42DfWlZFzfQyHxqLbEszSYaL
	z5u2lU+5Pv95b8VX1R7dRUm7fRX2ZE+jCQZ+NU3iCVjmXzVDYuiKKG1nSKi4LGusOE4RbK
	5U70xSBmVi/i2zhBkHxmcJ3G5PuNw+E=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OOEIRwd0;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf08.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768356388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vt6KalF0r8vwIUDZBExCxJCgnOwTB1qh1qLPxOxvRhw=;
	b=s73Xvi52nUY+2nuLm2xwOWx/UZL0sou0x9qjNuFUK+Bp3wdwPbiZ7dBQxlcI9j1c+354xp
	/UUvqAOQfdWMSY6n56LiPAg+MTf6P2CyX41IIWkuvnbdmqmJpQSsBUBfGYQBLaGW2VsheG
	aG+RFJiMrrdym/Astor/5Ygw6X1193Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768356387;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vt6KalF0r8vwIUDZBExCxJCgnOwTB1qh1qLPxOxvRhw=;
	b=OOEIRwd0nJDl2EoPlcjMZtZTfLJBKLiwiK0Usb1F8fmRD/pKNy9UvRkSfh6bcqL82LpbCR
	pAHnhv9hqEa9EcUQ9paKQsipUC0F+HthhhBfVvypfZMyg+GSvauD+ywVO7uuDIDa50+7n7
	lhXAMe79d3Rw33PrzeH6mHE4I4Z/rD0=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-602-fEQgJ9YAOiqbzV-F7C3eGw-1; Tue,
 13 Jan 2026 21:06:22 -0500
X-MC-Unique: fEQgJ9YAOiqbzV-F7C3eGw-1
X-Mimecast-MFC-AGG-ID: fEQgJ9YAOiqbzV-F7C3eGw_1768356380
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1A5411954204;
	Wed, 14 Jan 2026 02:06:20 +0000 (UTC)
Received: from localhost (unknown [10.72.112.63])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3A3941955F24;
	Wed, 14 Jan 2026 02:06:17 +0000 (UTC)
Date: Wed, 14 Jan 2026 10:06:13 +0800
From: Baoquan He <bhe@redhat.com>
To: Robin Murphy <robin.murphy@arm.com>
Cc: m.szyprowski@samsung.com, akpm@linux-foundation.org, vbabka@suse.cz,
	david@kernel.org, iommu@lists.linux-foundation.org,
	linux-mm@kvack.org, vladimir.kondratiev@mobileye.com,
	s-adivi@ti.com, linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com
Subject: Re: [PATCH 0/3] dma-mapping: Improve atomic pool behaviour
Message-ID: <aWb6FYTMJLsvDuTy@MiWiFi-R3L-srv>
References: <cover.1768230104.git.robin.murphy@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1768230104.git.robin.murphy@arm.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 00CE6160006
X-Stat-Signature: xauwzgys937deie37z5r9p9jgdwowuhj
X-Rspam-User: 
X-HE-Tag: 1768356387-315338
X-HE-Meta: U2FsdGVkX1+hOG+up1q6iTekC6k647L/BgnIXfMd+qf/vrnaagYr3SMzNnCbjl8LPMcXbuK8nU77KNHi9To4Q16e7eyI/itjGV2MskPZAS+CeckrpO0KJvT2HHiF4xOgJLndJeZWBfeaeuCT+MkCf5Vn/nbHQxWhd9du2s5aDzeAmgYQsYUx4j8bS8p74sTTogRgcJqYIPibBH9s/A6+5sEMr471+pVmWjJ+4DgRffHZ84aBgGHoMoLueSVfk/C9E9TTZvJIZwcbDBwP/BaaKKK2+Vct/585/kPDfng7ZbDUsKjWxFUHTwgoIxY/v/vBsAeEyeEbmPFSD7hspfErCZTGNsvp9wskU1QCHkwFG/MhFWLvvQ58yCoWB/CmWoP6CgqdZcZOEGNxfUN09m3Eao2ovqNE27K6w6m/Ky6YANRRudwAdJ4ivbd6gosT9+cOuxUa5/sp3KhsKOv9ACHyvSyVF3JKaHax5LmWEMqbZ0mJbwSVesHZg+o0gNF406pSoY6em+3DpU300w87dav0rJK9c5W5HhARZKs1OFZpiC0FVL10VJ4g9KO2YNeUBqJUyGYUwRM8Q9Te1fXAp87mQR4OyZ7+GP8XcjIhgtqAACs3HI7qQK9gNk2Gqh4Ou5alR36xOFjHq4xZ9TTpmtiUvGFQZsAM5biSBSReBFKlT3cgUTJyKPb9Kx6T0N4EXbW9pAEOYTVgh3jYZDgAa379z0XapDE2oJJZJqcTTw5DUT0JA0bDI2RsoDNtJvgiM7TsbazwkKk12N50zQj4blpT45CO+eeTQgykr4KgR2YqJ8fdeYtEujvpNivI58bNFdtQrTAe256qbX+anNJfGb6V9T22wY3DtyYTC8eUCaHzRbnvXEokL9jZ8fE0ent/n9zkvIFM0Mo8lI3jfCTrd1mpwB0udeO1Gk4NH1PAq1Hr/crp3VU1yeKkW7ibxyi8MsNEa1Sn8n0pWf3va5AR/ln
 y/z6878Y
 MoVQFGVIZflYK2KgqqxwIPpA2otYC+Zin+iwlFmCsxkPhJ8Z8WEgwiMJKVU+IBkDPBIHTqcOKKNWdNZB4teTPxQyNu02Se1dYJu2F+OASPcJabrD1KaooOSlPGL2I8Tnqr5T6iNr2OsQUik4xh/23rjwS5uSLJhBxyZRyhXp7x3e7sBG2CSpEIzNto5w1Vwcujt5fF06gPwDQ0776kqynVxk7cfXTGHjwKeKTPBIMGEOiMs8YYn4zvUgEhA7WAAOvt5/1+3afOaeT5HBKj7UCY2f3SKgR2/P+QJM2ne5V6EJswv3AnCl/BH2u+VjX6AqywOVgb9hR2KPwdTxwcfdaKl4wi06rObKCqvbEykVIEnLhq+EZx84zqQoNBFF1ZU9Kf4QF22HYo9eM8IHKg6fl0RYE5TV3MeFgdgqjW+fYQdzvpdgO23GTGyixn4QgZ5et19or8L8TjP8U7+MTVo1cxpEKgxeaLU3vtenN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01/12/26 at 03:46pm, Robin Murphy wrote:
> Hi all,
> 
> These days we have somewhat of a matrix of mm zones that may or may not
> exist and may or may not be empty, which the per-zone atomic pool logic
> doesn't actually handle all that well. It's not all that difficult to
> improve robustness and reduce redundancy, so that's what this series
> aims for.
> 
> I initially wrote this just because I happened to be looking through the
> boot log of one of my boards and had one of those out-of-the-blue
> realisations of "hang on, why *is* it allocating pools for zones it
> doesn't even have memory in?", but coincidentally, it seems that others
> happened to notice related aspects around the same time[1][2]. This is
> my attempt to sort it all out properly.

Reviewed-by: Baoquan He <bhe@redhat.com>


