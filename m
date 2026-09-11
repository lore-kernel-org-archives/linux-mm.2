Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A357C88E41
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 02:01:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7988E6B0096; Thu, 10 Sep 2026 22:01:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 770426B0098; Thu, 10 Sep 2026 22:01:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 685DC6B0099; Thu, 10 Sep 2026 22:01:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 38F586B0096
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 22:01:37 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6665D1606E3
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 02:01:35 +0000 (UTC)
X-FDA: 85199829750.11.8AB9EA0
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf06.hostedemail.com (Postfix) with ESMTP id 847FD180013
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 02:01:33 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iO4PZnCY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789092093;
	b=jKxSenrkMAwoRVTooUj4DAUerznWrwKwg6z0g7P82ka2Z3gSR8ih3NwYhRNKPvXbypwAXy
	mnb4+NEKkU1Sl8t8zNGOLHiyBpkiAbcoSjj9ADYNdwao9dtXPUkWjhpqhEqLDgat8Q/7wA
	LNDcC8wdv4H3oT14GWQTBP+tFVAVtAk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iO4PZnCY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789092093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2lwngQ9rxT1ESSfCU2zsMXvsP+GFu2zW1k7zlPAhs8E=;
	b=dFqb69PKzSUhNrpM3WRUF7ULfywsNlbPl1kl0eq0W3Qw1RhRkcuP87VazWIeWfy3Yo+Db3
	w437zX7hyachVcuBvpZM5F4Uvft7iC8z0kRGWSLEn/txo971wK6PBlNQHGr5wdntI6Yuy9
	NUYqd7AOLU5QN5K82mEJuKHvSswx8HQ=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2d6d28aa26cso2708385ad.2
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:01:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789092092; x=1789696892; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2lwngQ9rxT1ESSfCU2zsMXvsP+GFu2zW1k7zlPAhs8E=;
        b=iO4PZnCYVXoD8zJR3du9BP5tyIzXh4wk4Q1uUiiLVxUKFiElN6HDEgQ+XFRea1VeIp
         85LnAoivsccBG+Zt9gtTEGzazSsJ0hwmCHxFUfgvbh5nGheD32wQ3E/SllL9gwbtGv+r
         XRTJ66VX/YbgYvdsuxrNcNUSNF+0O8VMhUvo0woU3CT/6OmsivlpLxHS177Kt4y1Iqqx
         Wt5ePklctq0ZezkIMFd1eyDGsoqz+qZJoYX2BjIOmZIMxcf5WCV+7+cuTAjV8RJXWiEf
         dRFvZGf5FjbV+4NWkJY66om0/ZsgHYdh+6TOgoS5N8Vaqohck3XKT03FzTMLcRZrGOZZ
         bV/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789092092; x=1789696892;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=2lwngQ9rxT1ESSfCU2zsMXvsP+GFu2zW1k7zlPAhs8E=;
        b=DjM/oSUPwrc1ScMeWH5izLyP+PxeHMDNr6kkGU2U4uhy5ENtwDh2+KnjhOaPe+ohPU
         QBVabeeeNi6KAkRXdsq7UTTARNHroTrXQEECirJmcyNr3KzI3oQ9rbFuenTBlUm0V6+Q
         qdp3I82N368bxS1YssipplX1wscY48Cv9qLkW/wwkICvT0g7l3jDOvGmPWdwOzVkVBCf
         TJM7jkmbl809NHzgF0az8Hjaqi4NoyjXXeGVnzXX+R+d2tToiVdwI7OL5QkGC4UwN1mG
         dPFPVH1wWCO114d+9S84nCYNzK5dirl7Ra0IBRIoEbaaeuwgGO0yWvM+z6knLlQfNLY1
         JEDw==
X-Forwarded-Encrypted: i=1; AKwUvBxbDDoyfuef7c0d1VRn0fUQFlRvYIivS5fU/zeNLrCnmZqTdZBA7fJg6+83X99RalSyjnIF7rvNFw==@kvack.org
X-Gm-Message-State: AFuF++ljIrsTmpVEjZHSMJIK41TZr2vIl5xQR5IP9VA2ibNqtkUg1Yid
	6OQuBYEAJSNsAyIBQIzFWb77tzzzXDPEsuAZFZMFYBTYEYpSW/X89BzA
X-Gm-Gg: AYBFou3VtJCf7OVUyl2/gwELd/A2RWMGcRmHmJgjYAPC+ByXdl83FlUViWMNLRQT9Kv
	zKjYB5p79Y56aZHbX2a7enNbNqsEVN+kZFPwdOkPHPZoyJvvp72QUQ3QoER98+OdDfsAt/OptTa
	0qq8vzb/37Mox4np4RYxzjYqMRomtD6I7P7kouE44rjHrKAY/a1Z9lFiBBvdry8Dd4soO3lw5vX
	Rl1CUAbXP4yOFTz1r9CNpwig48jl8QVICndRjtkvdTdtqzl55Cus0FdK8QYWvJUPItCi4dnDKvg
	G4GAYEZG3uamjXYoN4fk+5B0l0j5WB4uVlII8AQZmYuaU2997ULQFoM5UobIpaEmEx1xcHhCBl7
	2ouyJ46N60g32nvWuTfO+TEy6fZXqCLNiQ10kPRoEbLjuQl6Aql88C+eR2Ad7aG1mNXRb9V6C1C
	eTC98ed9lZi0bFUBTK3LHxNSs9w2R6DEWKzEAWVB5BFVUHno4pnEiOGbl2Huu1E8b97Et0BzHsX
	iyCUFW5wuxt0xNIn52rPw1XjXGR0rl4BhMHcdCAXqJuScRm64g=
X-Received: by 2002:a17:903:1b04:b0:2d8:d4ce:9f37 with SMTP id d9443c01a7336-2dd2a470a45mr40913365ad.21.1789092092187;
        Thu, 10 Sep 2026 19:01:32 -0700 (PDT)
Received: from localhost.localdomain (vmi2317697.contaboserver.net. [85.239.239.233])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd2dbb900asm3052615ad.74.2026.09.10.19.01.29
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 10 Sep 2026 19:01:31 -0700 (PDT)
From: Lian Wang <lianux.mm@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH REPOST 5/5] mm/damon/vaddr: support pgidle_unset probe filter type
Date: Fri, 11 Sep 2026 10:01:10 +0800
Message-ID: <20260911020118.37585-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909140408.104699-6-sj@kernel.org>
References: <20260909140408.104699-1-sj@kernel.org> <20260909140408.104699-6-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 847FD180013
X-Stat-Signature: cjpdgr417muf581n6yif1hcosqeo93us
X-HE-Tag: 1789092093-482392
X-HE-Meta: U2FsdGVkX19XKQ9hW+n/Pm+a1Zg4D80fA6yFAmnrehMayNAgi0Dx2PNHBiACz88Vs+41Elmcd0ggPUZeVZujeUuCKPYSgeaLpQKAxniV1ZSgWTKHET5sZSude6wmwCGkYFBe51N3ROcuRk07ZAvrcQfIp3tpRUbnl+Md2AhJSm7SJmLJ8XMkI0QlT3B+lMGOE4GKu09yvxVhJSQ1ak5Ugv9Hbcpfyd8dlrGMs39/+Ae4wgjWsHsQT3aMPHtj+u18ot5uOQSyPudq6zq0gZFqBRMlKbfE9MT2mFT54AoEMcs4LDmfE8l3tC6WCaKTqIr+kVcvgXmUQRdACPWE7TvNZk+Luzwq9ryvphg8Z9MP9Eg9XWNmeVm7RE37NOpn7ZcKiyhU0OXMvqKT81oPV9NVKdkY5tfcQJnt3Fkez0dn8PzV//FVNQMtZbyE999bhFlKAWaAPtaV1paODJLjAhXDQBxJFzeUfFRDOQPKPaUTYXAH9ftO5TTUHvN9URKo5/d9VLkkMQgyXmWWl+U3pouypR+w+bO4MGL4cjdjYYuSgJzh9+i5MGViPFabSuHo5pbIXEd3CZQuhCpYXsFN5NIIPbQlB9Ilp0tDSNXtrYikMiK7LVdVXUniTBYDfc8OecyvYIhCl7qbgrPl3mIlau/SEiZ5Wljpt1NZSQzCMboHgshr8PZTjk0YIzPNSTHxpJq9HDKGFNmrW/UN2wUdW+7gLedaTJbozw4KWF8kvfZWH6FUxxx+EZYcIhJ0yj8n0eZ9HDpWUBgqCYe6a7J6QbTOIAw2V8y4BeQMzZzWdnm0P4B2zFsoEZAXAK3mBuJ3ES9yn/gJUQhILbgR7qrYJTGbm/ROHcmnCcf3Vz++p6q4t8OV03Gebx1POlE02+fQ9RJjVLxaPQmdqpb0cMpftVApIZC3ED0nKZ+/L8RU08dXvTaf2tYBYoD9E0vb4pK3JCrBLf8uY1qqqemhouo7rF6
 oL/j/Mzs
 RfC1DCoItBDC5jirf0E8cqrFC4YjzzswnXnQKqI1gOMHbbj6s0rNJSdXUSWCtPBS6vDT4pskjDe3QxtSUojDeXDBmaa43CMNBM2gZFZ1bTRHsdDIQq4xdAl2GI7mWCTZeZKgcJkWsFsa/REo0yWcD6zuLPZGV/7Ee6sAkTC6OjhiRacXpl66vqC0Ecy6CDaNb0mdiQjcSOjyeZMEMIfqemmJt14mq/fasMEhD7GheLP3Tlz6LrWGF9nYGJ2gjvI0O+FJnwwUoT33EcTQIpca5jefJxfiXuPv6U7dmW4VgOLAGuFFxX7IaZfxL6H286LTTHg9CbQjuy7HG8+mmeZAUZowaNk1WJAGmnurQ5uoF236PEqBJq61kLi7C3B8qRgOeAMkri9veMgsUxre6Iqvi9MsyEQVE1Q9D1uq/Y/EYIdyKwreWHwFgbVH64lmIr8PqYtP2vbDrVdp6GmcbMhhYTKuOrcUVGjr9l+pM9ClB0gaVPtx1IR8k1mfAD6ZcgxjunzplxEBHK4E7YnuEGMjTlnM/guWGiT/3ZPZA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 9 Sep 2026 07:04:07 -0700, SJ Park wrote:
> DAMON virtual address space operation set (vaddr) does not support
> pgidle_unset probe filter type.  Add the support.

This looks good to me.  Checking the PTE or PMD young state together
with the folio idle flag and MMU notifier state follows the existing
vaddr access-checking model while making it available to probes.

Reviewed-by: Lian Wang <lianux.mm@gmail.com>

Thanks,
Lian

