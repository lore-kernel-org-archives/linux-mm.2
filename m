Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F567CA5FDD
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 14:20:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCD0D6B0096; Fri,  2 Oct 2026 10:20:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C59256B0098; Fri,  2 Oct 2026 10:20:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6DFF6B0099; Fri,  2 Oct 2026 10:20:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9BCF76B0096
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 10:20:12 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 294121A0684
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 14:20:12 +0000 (UTC)
X-FDA: 85277895864.30.EDF5A4B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7E2811C0002
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 14:20:10 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HtXJYox5;
	spf=pass (imf21.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790950810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/3Dre78GSTEJXqtMWvqAY3FH4G63L3kygArBXnvuUPo=;
	b=omxry/x65zwelkVW5TGU4vP1GnP/04JePJOvPgWJV/JihX98NYebogGq8qNa0wVrAguTe5
	+kSOcokgPVQt2vJjvUF1U3/AwI15zzXCtvFYnZSTxI4BE+c89glTf2hvq+OTHdpWwvEOXF
	YMwEtt5wNV1knMWFhlj2CuMEgikoUSk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HtXJYox5;
	spf=pass (imf21.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790950810;
	b=DUNtK8on2HwtM4lpDCoFmBFqHZjXuAXU1YK6lpsgO0iXkSp7ArCbVEcu57xBvY6DlnjgrL
	42mbshSQiroLNZDtge2ec5XzR8BU1XBzRhAqqn8/Qhd1NBHeCbc5v8favi+NOWHtK+Ryx9
	ktr7HazUX0Vdelyr1G+1xV72suuhT5M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BE516447CF;
	Fri,  2 Oct 2026 14:20:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8CBB1F000FF;
	Fri,  2 Oct 2026 14:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790950809;
	bh=/3Dre78GSTEJXqtMWvqAY3FH4G63L3kygArBXnvuUPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HtXJYox5qqmy9W1ieadaB1RknAHgKwLmUCQ2sU5IOTM0YTPX50/Kma3TubfRF4VL8
	 I9y+TV8XHnaJj68Eh2mR9qwH4qXYAtHsRxXL/bfG475YeFUACLwV4UO0yvfwREgcI3
	 WyT17IS1etjXfrw6wbpUqvrfHO9thznCTLAbCidrHDb7bPIMQC2vCLDeb6UjMIVcgP
	 IYBNvv359VvgWL6n0haIO4l3RduoyA1UBW5MvF42IyEdtcb2PbmI0eNH7ior/4lqkA
	 RfmFzFM+cpZdu9YvwuueP/vApR1uAPzLcPXt4gbPJD3sb3QfRwTukK1uFhSMa8vm8x
	 aRWqyDCEVo8nQ==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	rppt@kernel.org,
	sayalip@linux.ibm.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Luiz Capitulino <luizcap@redhat.com>
Subject: Re: [PATCH v6.12.y v2] selftests/mm: hugetlb-mremap: add setup of HugeTLB pages
Date: Fri,  2 Oct 2026 10:19:53 -0400
Message-ID: <2026-10-01-1-daily-reply-0009-re-hugetlb-mremap-setup-v2-6-12@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261001181518.685129-1-luizcap@redhat.com>
References: <20261001181518.685129-1-luizcap@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7E2811C0002
X-Rspam-User: 
X-Stat-Signature: 5ywgiqw97a458spec51oa75hshpohund
X-HE-Tag: 1790950810-718687
X-HE-Meta: U2FsdGVkX1+GSsYiHPkf9CZP8i6aAUiWjtN4mw6g3d+aySTg2RNVfZ+OeFMorgo7bbRMPJRIDjJBqn7En5cg6U2wUxvZS10mbnGrvUYFjlmbh0X+VRfOREn0trcNUl0iQWUbZ13t4oYp+xJ3RzlY9ndqJ+nDWN7UIGMHsvHe1aXRAdCbNQMDcWUqCfqEDme4tMzi2qK92o7Ui4TEEBHQi7xy894yPBTsLg08cf9nV/uOFfZ+MN8Lzin+lVTZY50e47YcYH0sXlv+uYPI50mIohxL7Z2qaNW1Ez67o1Xf3GTWnpc8htPXxFO5Vl4CTw43dsK+EiU4RmSqghniUzcY1mT5V3RaIKymQIjo5JXRm57wBYf1249NTd7McwqXnAGh/2xsokagxRd+5IM8YxhMAmUULnGfwXUB6e/6PJAXGEjrfhTCPNNpx2RPamH6qfKX3Fhk9zRXS82WObkYOt8OeRqq2tqi5t33IQJeZRmNq4Nf2sh2oBLLnubJn26ATJfZRfStICTL7S8UDpimNiFTm0vfLEPvGoTJKQky+hC+TQlKzSzDlLb1NDqndBJVb9WENvbt8vcmWkRPbcSy9rbSgK+sx8qoq25lb6geqOwPiJx0NbVvTLDcDVjcc1o6keydLNrF+aUM+aZr3a+Sp3hIsWBc6FMrgy45b9wY4wSbClpWVCgIhIpb4RSfUkkt9J0QFrT235bt7Ta6Mdty9FnFkojyD+a0T/EEBb+av7TTC8uy6J0xo649Kwib5q+N4uJF0n78NUfkRIoflHkh8Ze1aBwbcLbPjinaIDL/9xa0zE7FqBJb9vUvl5V9V/Jp7ozyxqjAie9DMm71gzkOrBBjn1xZs2cu8I3ydU6PnrPnElJRuQe91/SfN4Y6TYufq6pOPCH2hQ4Nck5D1uuKRftsnSA7Ph/PiTGPVi0TdtsCotOYApCtexWYLRYJBEDZCo8FqLf2702le9rFdndn7HB
 6GcpfNyo
 oE2JxgmVos05y9EYr4tJA9Pcay2Ee3c9B3eJTVIgzPyt0fZ8XnsZ6z1T8FNGVTSGKjfbX7/GxGVF9Y4gfY+vUH1cgD7ucT6Ky0CyzzfPcNNlhNT7ChTC2qEbqIHB3gl6qoTOL2ybA/4FWquMppwXqij+jnrhyMdDTMK2YY931BMrYgN1E6pQu9QoQNlb3vGYwBjmBsYn6DykRNpk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> [ Backport-notes: this is a partial backport containing only the aligning
> of 'length' to the hugepage size.

Queued for 6.12, thanks.

-- 
Thanks,
Sasha

