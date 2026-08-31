Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4ACD1C624A4
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 17:09:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F5EB6B008A; Mon, 31 Aug 2026 13:09:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CE166B0095; Mon, 31 Aug 2026 13:09:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F25816B0096; Mon, 31 Aug 2026 13:09:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D2B1D6B008A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 13:09:48 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 73ABC1C0FBA
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 17:09:48 +0000 (UTC)
X-FDA: 85162201656.12.BB9E56F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id A17F6180003
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 17:09:46 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=03JWdFRt;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788196186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qJesAYSTVzpoXg/9Zj9W4p7RBJ2PVwQ/TQe4n2On7M0=;
	b=HbzpPDKg4zOGjHMAouTINxQi7w7cg/hPL7lwT1nl34H7dOkVLw0Cm6iOqJJ1dcdeBskgWC
	5DLniB6FxL9c3C/FOUe3izzaZcD4lH2NZwuKpkit3XCFWvyt/lVskqHlSBgHua/0zaWOT+
	atTwzfsZC5dqSXadTKCNfFDZFqKdSuQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788196186;
	b=u6eiU3HHuOoiR4VFcH8N1jXij2xTaFO4CTd8FDlttT1vUJM6lD8IkeDdfhmosBm7zsQVcp
	YDjmmjnQWMeL3dxe4yDG+rC+a4nwt/mqnM6PivOnls3dtQPR5C4JXyowqVBbQN3CU4qHTQ
	feZGVHDJRjlmFkoZnSlOUotAXDMVPl0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=03JWdFRt;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6B51C42A1F;
	Mon, 31 Aug 2026 17:09:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 131FF1F000E9;
	Mon, 31 Aug 2026 17:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788196185;
	bh=qJesAYSTVzpoXg/9Zj9W4p7RBJ2PVwQ/TQe4n2On7M0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=03JWdFRtvhR6VDV6l0PUGA1DVunpqddI6VSWXI7dNneFUwRvZ3V6Dx7U6aGRkK3M7
	 PLcfwDkv+py26b0n8Lj5Y0GA2w1/IcEx6iHOlg7lrm7IlsnrZ1AEovAIcVX0coIofm
	 Wj8rKpOXWwJABIA1jG+/4VHCfqVr+8y0MsMXWmI8=
Date: Mon, 31 Aug 2026 10:09:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Taha Sezer <tahasezer.is@gmail.com>, david@kernel.org,
 vbabka@kernel.org, mhocko@suse.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: vmpressure: scale window size based on machine
 memory
Message-Id: <20260831100944.ccb2a8fe3b036ff7a258820a@linux-foundation.org>
In-Reply-To: <apV_VwQx-7qXks_a@lucifer>
References: <20260831130316.448-1-tahasezer.is@gmail.com>
	<apV_VwQx-7qXks_a@lucifer>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A17F6180003
X-Stat-Signature: n1hb88zy9py1e5cxxqwtm91ynxzijw9a
X-HE-Tag: 1788196186-84490
X-HE-Meta: U2FsdGVkX19zC8fShGKkAJ719dZRbgg2F0wOM1uNvpOYmer47Hkez3D+6js3yyzKGXHmZhNlPCz6DvONA3nv2/CryiYTTpmEmg124D1dsRnDPkldKpaIVM1LTRn5bsQcpiemJk7mg8VldX1/RDqjBM89sXWksL5w5OQ7GFVE3L67ml7JA8/o5GRX1fk4T4EaM0dwaIgxt3ejvB7+6jPxGY+PaQ7ezHU+kftC+bwSRa2CKdHGvrLc7YEsTSYGg7oZpnSROhzrjFyxNhk7ufFpQCj77KM0cHbkiCzMMAS14YyToOstRPlTpuApg7FrIrETbYrRpi7BAg3/pZfQ2epfZHK+2W6SQ+KPe3/MFOcBCmzxFKZokxI/5r65UzNFRo0Jj/Gv+yYK1LMbV5BSEtWsuVQ7VD7xXrrr8IBMXKXqOQL5TpfX+0m7/pznvpmTZDWRHFOKD0We+2LHZj/B49tii50GTO0FmEf/4dNwT+5hJ9e8C6vtgmkPsILTIlgb/IcXjU/BrVEUPCTB5FxDE8rqsy4/sHZ1WzFh2wG/rqSKRCOCqn1DIvuhcUj+tnc3cfKud3DNl218XQnmOVdpH6uMCxf9ws1o/gK/88x8h40xzvyLfK9ziTwuUvaigaeNjPTH4xfxfOeOqtJM/bM/WoZQdLkQn5jaam0rexlH+HMY3+uzEc46lIeAQu75hvgXTeXbARgBGT3Y+ZL/PZe2R8pU6dLjKvCInq2n60RgRflXkY5mBDfMcmEBolWUYywWYTOXXwRVT7O1xgTieYD1tU7+GSS9sznzn/Uqz1Q8panP3Jq2pW7JPMGxqMHSnnKwkc8cHmB+wXjueC83se7zCyDsldw7CIg7i7qWG+UoUe0ZkkHHwo9RQiNNC0NVMsypWIZB9333SxOzNtghszBG+MvO9fFE0CDrMIszDIZnpr402X4ekyxhkjKo4t7hg8m1y6zRIlbtt8EATvdwaj3rAiZ
 WN7Y++y6
 VVewBt3geo5h5BHcnY3z0zzjG5OiVouYrBsG5u21vv8lxjvpqaiYWp+I0Lxq80Q8IF/wmeUSv0QlXTP96PpoPhK48iO4sFIP2h13Bkfsbb6F3OXyfemnIcQ7X9MU6Iq+MvJGHjJicye3+JzgprqQ3cfK2hVDWNLgDB3Tg4II6rieB4IzgfqxzoUrtDdhrwNDmwq/4xYOEI9Em60vxaY0PD4GD2Tu6at3yM/haSkNCCWSdV8FWGgs/ts7MpoFmew2u+RO6Tl1fKhlblO8H5Zn6uSxj6qRrVQZU6JjQUn7Lv91/c/1EaOBA6fbTS7140QAe0Bi3U4+LoqwJwIN9twnVBbZvrN+yp+DFIDFHTyiC49jz3x6YKMO621d4w396rIWTuwmudj3UeRynBHF1QpIocc6bH5HvByLTxGx9o+rnM3ROyfrfTFs61ws7qQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 31 Aug 2026 14:27:32 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:

>  I do have to ask if you're using an LLM here?

If so, it isn't a very good one ;)

I asked Gemini to write a reproducer for the Sashiko report
(https://sashiko.dev/#/patchset/20260831130316.448-1-tahasezer.is@gmail.com)
and Gemini told me

  : You spotted a severe mathematical regression in that commit.  Your
  : analysis is entirely correct: the patch actually shrinks the
  : vmpressure window size for almost every machine on Earth (up to 8 TB
  : of RAM), doing the exact opposite of its stated goal.
  : [much more]


