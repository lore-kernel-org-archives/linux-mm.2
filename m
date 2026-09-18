Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D1EEC982D2
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 02:31:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDA496B008C; Thu, 17 Sep 2026 22:31:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8AF36B0093; Thu, 17 Sep 2026 22:31:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA1AB6B0095; Thu, 17 Sep 2026 22:31:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B5A536B008C
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 22:31:38 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 144A8C04F8
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 02:31:38 +0000 (UTC)
X-FDA: 85225307076.14.E9FBCA5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7A899C000C
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 02:31:36 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OSB1Wta7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789698696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XliY23/0AK+b/F4nmqsY5oKyNRuUkycysRCvuehdnhU=;
	b=I+Uqj/I0kUOismsPv2Y/NENuvEC/EZuyz73XKhhbb+a5tJPX+iA3wOkrz69aFrX1JvC7AL
	2esvHN9SQhlus/e3MkK8L5bQYOuVRH7gzFJsYJyESHWWsEnsRhr0FowRC9Wt9jjeZacIBZ
	yVfMF/N/Y/9T/WAJ8Z5qKMHxyWLWnjI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789698696;
	b=ar9P6dkIxD3uqGwt+HDpyC30vcqilcA/CeIloSVnzOE1A5Mx6Om/bqOoS6VRb+7YKa3eeZ
	Eh96luI+ZWcy+dbODS+hb1QPKhDjXd8EG/VKSnm/S8qABmDsKCaEm/K7TVtHTleTIrBlRC
	nkaGuKDcbyvv/gChKKGhe41Q9kNzfJ8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OSB1Wta7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0CAFC601EF;
	Fri, 18 Sep 2026 02:31:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51EE61F000FF;
	Fri, 18 Sep 2026 02:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789698695;
	bh=XliY23/0AK+b/F4nmqsY5oKyNRuUkycysRCvuehdnhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OSB1Wta7SjTqCXufn6cISCnqIIR9y7c0SBu2UsNrnWsnBZ4VtusSsfysx0WGm858h
	 NQIHuv9hIOGLzDbR3UL3i5RUVV2F+hmKPHNen5L+U2QxiOC7rcUkomtMZTaaJWvy1r
	 wflNHwJHXxaSP4wNEPP/v23vsD6hD0n5OmudRpcRBj0fYyv23luqXKL6jzPanWo7+f
	 hI6ZP6hnopSzQ2A3EWsdJsz5MqC3rJeAh7IQadk2Ic1CizeqACZWyIWkuEWg4EmJaw
	 sRi69bzXOsGV4FH7ApUcyYfm5WRMB3Ub/06KU/dm/rFrrIrGAcfTHh+pdHHu5Ov+ep
	 uF6tmSrJmxL6w==
From: SeongJae Park <sj@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: SeongJae Park <sj@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	linux-kernel@vger.kernel.org,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-mm@kvack.org
Subject: Re: [PATCH slab/for-next-fixes] MAINTAINERS: update slab.git URL
Date: Thu, 17 Sep 2026 19:31:33 -0700
Message-ID: <20260918023133.13375-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260917-maint-slab-git-v1-1-d21a5210aec9@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7A899C000C
X-Stat-Signature: 7whh6u1nnsszmhgd755xuurjgfo749td
X-HE-Tag: 1789698696-358248
X-HE-Meta: U2FsdGVkX19vKy/H63mcBM9QDITx545tnCbgVa/erO6goYhy7LdOXBtf+6/fUZJdii3HiPmQAOfIvR654g/2V0/Uah6qDO6JsY6FchgqUoK733+v/ymBiZ7w7pDDYTSKQbxPWguNuHzukN4k99rmbLUeAdB45/sFyutBWfquJVlPfIrSBUCLUAajUHEmrjV7VvFCj+uWKdXsE6b8J61La1wjMDH2faiZ6GZlZ/QKn1E4D2WE65E8Rw46sKeS6CI36iswZG9aYgV5okUGbJCNuGWhYRd8YGAkQ0gFCRsxOtcWVlmi/BdYMXYod7MEpadHRAdwxj//P87iKVCnvs0ZXYH/rBZQt6Xj3aWIieVnBbWAtHJwuLsJ4vYcx4FUnkFdd5MCyj+jr+Kg2DSZuzVgY1U3XRJ7GNe5NL35bKZ6SLB2Sy18KE1noB3fg9YH0seooibJVFRhEq+roSsjr8FuZRcHlmW/4B0JAdX4IC27r+zMWZmCGplfaKeYpCZxydBQ0BttBV3vJSKL94MkUbRGjNtcsY8qdfDjcpxiht+IdCp60+yDbU24UAsGGzVxFdLVQQ8biL9NB4YuN09CzSOXDlmlnwHC1KGn/U52WQmJB9Z8OGWPNOH44Iz7XnCZin4CgQc3IfLitUf4iPQZ/Oayq4mHe/J2pLoE+jHYF1A7F+u1wgyxtSj7gxY5nrS1Ig0z1LXoADH978SCzy5i9HgrOg08eMG52mkrbx1XNX4SOvXmmTzesUH9g4IIM8DQZdMXU4NbRmDWyy1V2H80KIaxyDsOe5PHlxwAdfBk8wZ2/yFDnR98kMC8kvvUc5EBMhmFjQSqOLrLq9UgFRo7AVFs8GqLmgqevrPWkBog1fKse81Rfve4J4IKQ5LZiTh+SffVeVx9HnMMbESrVIsCo3uq8WslmQKdqZLLh3lH1r0YRAv3gJqqs7QvFSM6Z8YnZ0RoTACTwU4TJVMwmBhZ/BJ
 JIU3NEFY
 FPRfHSFCJG8y8A/SVRjsYTiufFUR5x8yvMxuQv9AQCDz2nXJz/XodDQpLmQMQEylqMUOH7jkSWdk+xrmadSAaaHkJz463OMXqcREF4/79SszL9Hn4MP81ya8RBspOpwCE+sSfTWs+9LIX7E9K394Jprnfpqrx6gnw1O6hK+WQZr5CL8XoY3OKzkJVrVyDq1XxFCvsCDo1FsL88VVLtVQ7vTdOYPOvpeHi+7y9X2RR7mF39hk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 17 Sep 2026 16:38:37 +0200 "Vlastimil Babka (SUSE)" <vbabka@kernel.org> wrote:

> The slab.git tree has been moved to a new URL as part of the mm-next
> integration. Reflect this in MAINTAINERS as well. The old URL will stay
> around with historical branches and tags.
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Acked-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

