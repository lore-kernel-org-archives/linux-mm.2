Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D2FDC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 23:57:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04AC06B0005; Thu,  9 Jul 2026 19:57:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01A276B0088; Thu,  9 Jul 2026 19:57:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E729D6B008A; Thu,  9 Jul 2026 19:57:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C7D656B0005
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 19:57:37 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 43DC340319
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 23:57:37 +0000 (UTC)
X-FDA: 84970902954.16.02EE28E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3635B40005
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 23:57:35 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VGvMFIuG;
	spf=pass (imf12.hostedemail.com: domain of djbw@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djbw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783641455;
	b=b1GgAXV7A461aDuWeVXlPoOZ34R6uLn3d+8hzIAttJ9eZFK6kMGsFeUDT2qytd3qfU4QsR
	WnLsQUFsCbEbWFPf3wisco2veo8Zkd8rTrHq3uMJUWQuausvT7225Mc1WYL3EiNUlikMvg
	EBX2FOAUEoxMO5BqXm5xiH3anZZGY+A=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VGvMFIuG;
	spf=pass (imf12.hostedemail.com: domain of djbw@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djbw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783641455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NL6KkE+XGM13rjECEPlDsP8sDmlO2+4iY80eSoJW34k=;
	b=7PW3nWgz2BbXR5ossfnVvBHFKK2l2TKYQASAvdniPvGKzzvP+EBpuDUT2Ko/OpcyrJSdEj
	3wOh08OiDgfKYgYAm7nIag0V5W6xisY7HgovMkGqfB7YVzr0KTwk0tWN4CPTv/witSbFuI
	gaxjLataw2JuI4ppceubOAICSQdoCMY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3EDAE4505C;
	Thu,  9 Jul 2026 23:57:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 418A01F00A3D;
	Thu,  9 Jul 2026 23:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783641454;
	bh=NL6KkE+XGM13rjECEPlDsP8sDmlO2+4iY80eSoJW34k=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=VGvMFIuGD04PIRzU/JMeGvWpJXoTWA+IBrWJ4DETddqsvMfFiGavTTa9l63r0ClWv
	 X2UUQqNqpZqczRFyLqhZ+Zy8m15reHdQPTxmbUIl38NqaY/9+pMPbWiYC4uxdsvauQ
	 wiyhThJeiv2vh4H7xyufBRg8Jf3VvutnySvhp/UkfByFzJVEb/o6mL59688vpOGA8E
	 /KtI4FyfFU6/yE1N8/6ajHygAZKQzXhv4MUIjJQ7ZlAJqRmRYhZpdgugODmzwu+OMS
	 LmeVZGAdUBW7l7GzygghdDpLsz0oELPEdGv7JVw3JmP3iGheo/4T7jidFlKAypbciy
	 7bI+bsP27Yw9A==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id 5ED64F40068;
	Thu,  9 Jul 2026 19:57:32 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Thu, 09 Jul 2026 19:57:32 -0400
X-ME-Sender: <xms:bDVQalWT3kkP1O_nPlEUgaGq8m8QWlO5PPNjznrDe7d1CpTWIfMANg>
    <xme:bDVQalv5hmJ1CwhK2dgiJKfqcKH5_0MDF8nquspQ3CIiab0qCEzQOUNU3wTkB6jqA
    qux6Ekbzjl6ev_KByOlE4DpQciHdJVr0JS7N5fHu8-OEkyJk7RLkY4>
X-ME-Received: <xmr:bDVQavNLOvwweJeepDKvjUahneSQU-R9SYF3Ap5jl8v4MTmiRC2Md5MF496hZvJ_k9lFsj2yuAX9-jTBk3671HtMbzuA8Bg0NRc>
X-ME-Proxy-Cause: dmFkZTFRjNBlnTz3PRsAmwjqRoF0mrjGm979SwqAKHEfthIBDq5uh/i9WRUkVW7VZSf//w
    YDoaw7hRG798DaAYdC6UbfhFGRdHF+jU+/jGu6HBle2Ytf+9RWyMwBDwRmckEaZLf/nUyQ
    SKi5sJRgbDjlp94ASRYw/4muCvkc2xHnl/vxqUx1y1DhspUjPMoJnbB/bl00rpb5PWiQyg
    GTtZWI4G6plLyhOdjNWH8CBGphBXLtH3D2Pvho0pAK+KnWiAORXsSOpMdV4xD7ID8QXYje
    a9mh9aiUSp78AdFrJ9O2B3vkzu06KG1gqyHdViPBwiRVrcIhbVPJi05ziCPPBR/N6vYfer
    6lrpXziKcnjva9wT7p5QUwgxDdC5jjdwT7fXiZidMKAEs3vLpiGVt16GoilNTbBE1Swe66
    lq1nYogPtBgSjvZCHT/YZLpCIqUO4TamHC1Gj5FtyOihURCc/3jiGGJS5HrnflvJVUhjxl
    uPu1tEET6rrY+yW5GgTNYjuDoKs+MzBD57qey3Z58xdp6wOjNRKNBRIG8N4BLdwR9dsmCv
    A4RIo/MDKkVvsbyt2hA+z7nruReU0o4mcD3lQXH5OqBkbo9AE/nGnLS1/bS/nnG97VTtRr
    clacuChAjPCOEchopHVZNuyYh3E0NUuVP+WPVNPQEQOSK3N74GMuftNUjPxA
X-ME-Proxy: <xmx:bDVQasnnBxeuM7jroXxksAQB9zn6duvpKmyvN9LZYwI-PdaHUkJUKA>
    <xmx:bDVQatz0AT56AL-iX_O4imnfAPCevJDLonBYOOcGBR4lexJTusoU-A>
    <xmx:bDVQalDdKFvxjIjyCfZD792xaNLb2nqmtQGGLIeFu5A_OdS7ISVbsQ>
    <xmx:bDVQal5BbtDERhJ51QOg_cveb9aqQk1z5niWGshAPguYIvTxzRtlwA>
    <xmx:bDVQap1K540U56JdRBFV8JSNUnGOGG8a2VUV2cYjZ6gcar-XwgSzqP4U>
Feedback-ID: i67ae4b3e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 9 Jul 2026 19:57:31 -0400 (EDT)
Date: Thu, 09 Jul 2026 16:57:30 -0700
From: "Dan Williams (nvidia)" <djbw@kernel.org>
To: Gregory Price <gourry@gourry.net>, 
 "Dan Williams (nvidia)" <djbw@kernel.org>
Cc: linux-mm@kvack.org, 
 nvdimm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, 
 linux-cxl@vger.kernel.org, 
 driver-core@lists.linux.dev, 
 linux-kselftest@vger.kernel.org, 
 kernel-team@meta.com, 
 david@kernel.org, 
 osalvador@suse.de, 
 gregkh@linuxfoundation.org, 
 rafael@kernel.org, 
 dakr@kernel.org, 
 vishal.l.verma@intel.com, 
 dave.jiang@intel.com, 
 alison.schofield@intel.com, 
 akpm@linux-foundation.org, 
 ljs@kernel.org, 
 liam@infradead.org, 
 vbabka@kernel.org, 
 rppt@kernel.org, 
 surenb@google.com, 
 mhocko@suse.com, 
 shuah@kernel.org, 
 iweiny@kernel.org, 
 Smita.KoralahalliChannabasappa@amd.com, 
 apopple@nvidia.com, 
 Hannes Reinecke <hare@suse.de>
Message-ID: <6a50356aa7a4a_3cabcb1008a@djbw-dev.notmuch>
In-Reply-To: <alApfp2z9Thyan16@gourry-fedora-PF4VCD3F>
References: <20260630211842.2252800-1-gourry@gourry.net>
 <20260630211842.2252800-10-gourry@gourry.net>
 <6a502267b17cc_3b7ee51008f@djbw-dev.notmuch>
 <alApfp2z9Thyan16@gourry-fedora-PF4VCD3F>
Subject: Re: [PATCH v6 09/10] dax/kmem: add sysfs interface for atomic
 whole-device hotplug
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3635B40005
X-Stat-Signature: 373mj58ohcc4n3bpmoaxb96iemi1ihnb
X-HE-Tag: 1783641455-95386
X-HE-Meta: U2FsdGVkX18d8G/4ohzPf2YSCANj7Ezlt3aBUi3AOPdd+BV3PnsNM2FJc19agUxmhSBVCbNLSlT6OS/x0qmlFFKFwxk3ouLxKOJEYc0FaViZjWgomMH5h0Fo6x4MX8Q0HTXesxQLB5YQnyqz7IWRi9/6VkTZzA4CZr5g8X3/b94ACUWYY0FoMgP4s6Vvfst3sUYOqiSMQJk+mnxFDPTIIwy7evasjBEP1QndRYPDHsY9QMPZm/07ObIF4335Dc+emmNU/HDWFee0rRHTl5z8oSbkVvEyo1MT+QA2bQfwWimnCU5/I1EiUaKT15L5vEUYrRKEwoSz39rO3NsqulkLp4/QwblC0+gunsms7lSF4nIF61XENBdGXhbvpmNvnZrYaDTA3fsy7O2f2TEgiiEoma02gPuAXH6h9i8BwXKMstIMaZLZ3SSEQDu5Sdpiq3KTHXfDvjXzGgfMkMRvDyjvebCOBR5W5hnMW/uV09tEf3U2QI+5l7INj6hFUOycnyd4wG3luPSGi3IgjyqqLGNMkxibsYVPbUBAWtEc1yBR+nTk1iSdWlETfsvY5uFSSOt/DsINv/7kvrM6vmhmF1t9V/nv1A55XiRmxNZuzdumEqdyPAlFkecJBJ9GlcsWVY4cqKQ83rsDLrOa2UxCPT5TOfD4jNrAMrVsnVOh7viShYn6PNb6gozyWZ8emw3SuUCXT9e3BZlG+VRqe3sv60b2IocAtTSDHNSf+Jp7n+JF0mQQIa+jBBo2K1SFh2LiGDFv3T0MIWhrgnYZMXxnF8RL7Cpw32ajKWDiUUVjJv6XbdDEk+XAPeIlZrbWTvjqskRtBwajmUvV/OFunOzOhGFa/FG5r4YeknVbOXrMb64qyt2e/WL6x2FerchkKklfle+wt61RBOrv/mMOaNepVGKBCJYLH2H3/YAP3F6aPYFgIJQ94CF+CeUkeTVGpseOr5NpFCnqNOedUKTCb56TjqT
 sElU4sXi
 Hh/3HOK/NWTA62EDlWN/68QEGi1bpdkYNpFkQaQo9+Gxo9iCBmW0YB5M9Qmbl55BI7lhJbrI9gSXhhc+qJIC232FcyeAN9sgQ+mD/7VmnYv+ywXluyr4JGiKOOTsgEQEFtEldA8sP/TfAIYR3zvVgxyILhE+71fJv4zsWtUovNxTdx9HWyEAedwMhDXw0W0ek+gmlo//cwqTkdlNuxY2EB3LLm5zCspI+lJLtaEvMNgmYx3Ja+WrvoR8Zc0ILm/EiPr5HCSzdaslr7AT9gNCnyrzO6hPBMML19qvA7zoozPfAphXdwKt2Y5mgZ4pWJoPCyubvag/wuIzZQS7Kg1EyFq6j/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Gregory Price wrote:
> > So the "unknown" case does not need to be here.
> >
> 
> mhp_online_type_to_str can technically return NULL, seems better to not
> just let a NULL dereference sit latent even if we can visually tell it
> can't happen today?

Oh, makes sense I was thinking "unknown" was only a result of the
drvdata missing case.

> > > +	if (dax_kmem_state_is_online(data->state)) {
> > > +		dev_warn(dev, "Hotplug regions stuck online until reboot\n");
> > 
> > I like that the BUG() is avoided, but I think these should stay
> > dev_err() given the severity.
> > 
> 
> I had to go back to calling remove_memory() by default given different
> feedback, but I think if anything I will just modify the BUG() to a
> WARN() and call it a day.

ack.

