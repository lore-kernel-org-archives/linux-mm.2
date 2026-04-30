Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB971FF8875
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 14:19:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52BDC6B0088; Thu, 30 Apr 2026 10:19:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DCA96B008A; Thu, 30 Apr 2026 10:19:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CBAF6B0092; Thu, 30 Apr 2026 10:19:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2BA466B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 10:19:17 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 35127CAFDE
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 14:18:26 +0000 (UTC)
X-FDA: 84715427412.08.13C6D96
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 49A6D14001F
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 14:18:23 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IZE42bMd;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777558704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=nh2mR6kGZykXLyWzoVkEz+QYUMv4I/Up6a/qZy5OZfA=;
	b=W95UI1H6mA8ze0ot+gnv2//OU5BuF07NVH616ItXhrx6C+M9ObtmXUJQoYih1IF4JOPWu2
	V6GhgO9Orb02bkSh7yaIHNNhw7CS7YAL0fmLUN2xzc+SGpGD/sVrA5cIdCzqKfrJbtB/eY
	TbTIvEMIO+OsD9VqsL/C1DLW+RCaXUE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777558704; a=rsa-sha256;
	cv=none;
	b=yVrgR3v9UhAV1lwF20iIV1NYdALfP5+Y9hxoNKuL5+EpctteHEZVZBwVZRJ9YY7NphQcJQ
	3iJ35k+r7gh8OaEY5bJnLhW9/3uHoK0s9CqaYnCeF1tSHPIdouBqGB3TPHF7NXjvQOh0xU
	41UGMwMnSpKfikaBN9hAy4DFji/uvoQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IZE42bMd;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C9C6840E47
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 14:18:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52501C2BCB3
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 14:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777558702;
	bh=FMW/Zc9v1x0a+hmZhPi7B0rsfzce3tf3/cPf25CaM2w=;
	h=Date:From:To:Subject:From;
	b=IZE42bMdvbVi+dwMUxAmF+uftybnm8httmD6HLfTCqRs4oObSWwifrQKdG+RoZty0
	 QBnw4gwwj9zLjmZPI/IeZJm3DOIBbAqVAxvG0/t6UgUiWmikxmhnixUSgPJJZlpAuY
	 rVWM0c1rlMoML6/XhWkR7BUV2OaDVXULgBh6Qs+jncA7ziEJLEYxIzeTlnUt71hUE7
	 OldSlKt0l7jwoZWmDTfqMQbOxGnqD3J6vrPPSxtvMcNak/uHEemqkMa35n3uoJYqxE
	 P3lyeV95XEwV/wltbsPXJTt1RRrW3+mhCZxIPMvVc31POgNc/HDQRg+W99gRK2GB5N
	 Fql26cn26E2bg==
Message-ID: <05cf9584-e06c-4ecb-a5d7-2a558fd756ce@kernel.org>
Date: Thu, 30 Apr 2026 16:18:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
To: linux-mm@kvack.org
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
Subject: [INFO] Limited reviewer capacity in May
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 49A6D14001F
X-Rspam-User: 
X-Stat-Signature: 65fdih3iie4ucef349qx7jz4185xqxop
X-HE-Tag: 1777558703-38883
X-HE-Meta: U2FsdGVkX1/0VU3ODKlnjNwMZZUwdLNxejBfIMPhKk4zEO8Y+zEd3YDHJWTGoHycUMlNHnKhS5ki3JFSlo634IBuYKG3wadPR45Oi54KPC5T2uxEwt0VbIbatMd5hpRmN9Y4yrZ8wP3em4tjYkuD20929Bc/pbeP9zDFR423OAuqImD7llpRBdUfQE43ae8qAcRH8gP+8AtNoW56UqdNNkz30eW+W1hoN+TWLIJS0xyTvQCXK1odUzzq0jUaT+uaaJCIWbIxiTgMD0s2/9Cqmy/FzrsS3upSNUPrXzHEvhErzVgcXKomVjCP+cs224T9oLQ85cfpJR+VqfCCwHXVzWCYhbBRwtFVSkRUreZeY8VrTg8YOWIq+fqhXe9l9XGrduafJstZUVSiiC8E2rSwyoclXWJW5vcaOzjhZAT/tEUyOuXqHgpCRxWUygSNDOGTxygXXz6nyAlwSndq4B2le5lki2x0of52yEkNpbF82G+SAkG5yMyghtOhRrSDDCe6B2edPC/m5o3Nkq3vuhD+hDpkI9Hi2oBuhjd0lsmsjlra12PiYnXYiblyES2NErsFLcuWsd0y87dl7T5y66vFq0Auy3a/8ZaL6/j7MCAlRB62PrAtjMtAdwQKweHWh1U5nsec9a/aUX0VqgsQxbbPWCsMnyX6eazoW1hd3nl9VfhblF5hv+U/7oeYgsHxp7uQ/FsrnMVWsiWkpOvsVyrvfTYzXNA14dhmbYrxloYqPr1wAtepmgPbXVk+s01SUaIpHFXhrHFdnhEJNbA7RVK7sKeSAj+VQkvn3nJMU96OdUhCZ+kskBzpXQ/vw4WhVK/f3wHzilbVhX0+X+yDzxQALpEB8+SwfmSwVtzQoPRVPNs1P025bTTs5Cc4rvgvFq6cqaChrCsGAuwDnEcW3P3TYAdR3/2GnO0ubZTilmV/GmmpywEnlGE9P0yWFsOQsDc/0TK511HXV9/nGaZbNwR
 miib3STt
 DbEEtdVcCoMblUhYHWRgnnSpM+wcAmyMg39l6TyjBEG3grdk2ry4vEYKhNWVd9MOCamPx08saY7xnG05ctavWAsBbCe0xM679Vrj8Bym+qwER28L+ldpAP4rrB1YgxGWWxSWO7NRffxL5Ih9a9VOwyrE9gpghraBDnKjo9VLsl905v/BPN8YBhn+GN16rVQKwNRQRZwXwPoNgjIGFHiDbCw7iEyds1Il7p56cP2ny5GRx/QMV3VUCqwo0cVxqevGFyxxfFG/cBM3zxpuhgxikic1/dQbfRobMqMYO6rbj1IFc2BOYckbaf7DT5+w0F2DaHt18
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

this is a reminder that a lot of MM component maintainers and reviewers will be
traveling to Zagreb for LSF/MM.

Quite some of these people will have additional vacation/travel coming up in
May. For example, I will be traveling most of May (2 conferences + 1 short
vacation + 1 longer vacation).

So expect reviews of non-fixes to take a bit longer; I assume most of us will be
back up to speed as we enter June.

-- 
Cheers,

David


