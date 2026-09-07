Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F25BC79F99
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 10:24:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDA206B00AF; Mon,  7 Sep 2026 06:24:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3C196B00B0; Mon,  7 Sep 2026 06:24:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DC436B00B1; Mon,  7 Sep 2026 06:24:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6FE396B00AF
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 06:24:32 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EC596C06D1
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:24:31 +0000 (UTC)
X-FDA: 85186581942.07.549D8C8
Received: from mta1.migadu.com (out-39.mta1.migadu.com [95.215.58.39])
	by imf27.hostedemail.com (Postfix) with ESMTP id 49C5040006
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:24:28 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jXPzfFxX;
	spf=pass (imf27.hostedemail.com: domain of dongtai.guo@linux.dev designates 95.215.58.39 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788776670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qdrm4DNBYm5dX7L6mU3n6kjCzAA9iq8Muamy4PiEFn8=;
	b=bOncWW4XGKy8Fn4J7BAjyysQpaxLCJ7b03BH62GSUklLisQ/YlEp/Rj4nbKkffRXamYC/n
	0DJS0Z+d3u+dJss0fqZNY0rF28iKfeuhv18dsOaqTxRG0QjcQKQZGFfb4No+FyGHzJvOlU
	fIoB/p0MHMpBg4nKcws+Jc1cGqrmKzk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788776670;
	b=Ia+dKH0VXlexyma3pcXBdldQsmMbgzyQ06iZoXI+vOy6TWuz5K37LSJuJMaak6RPu4nVbD
	ML71HCmfBDcIgAUj41NEeeuT7Q8ZQTvoo+btt2sCR7Mp4mw94QIUeF9UgF+iS6pQEEvxck
	Sz/zHXPjWDg43omugmFy1ErJ9Fua3cs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jXPzfFxX;
	spf=pass (imf27.hostedemail.com: domain of dongtai.guo@linux.dev designates 95.215.58.39 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Qdrm4DNBYm5dX7L6mU3n6kjCzAA9iq8Muamy4PiEFn8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788776665; v=1; x=1789381465;
 b=jXPzfFxXodFwCehoxicliV7n6rXK8tL10JO3L02fST/m0SbITPVMsFqJt/5Ew+Diy0YF9swX
 LyvcK9QLMGzlnjvP4pyGEZ2TB9tZWbF7uJjRGRHogD6/4UgJ7dYgzPY3XXtlCW+3qbXDG17P3FK
 +CE472NHNPt7+m/y2R31wvR8=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 06a3db8f22e82ea6;
	Mon, 07 Sep 2026 10:24:25 +0000
X-Mizu-Trace-ID: 06a3db8f22e82ea6
X-Migadu-Flow: FLOW_OUT
From: George Guo <dongtai.guo@linux.dev>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	changyuanl@google.com,
	akpm@linux-foundation.org,
	Huacai Chen <chenhuacai@kernel.org>,
	Kexin Liu <liukexin@kylinos.cn>,
	guodongtai@kylinos.cn,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] liveupdate: kho: calculate per-node scratch sizes before allocation
Date: Mon,  7 Sep 2026 18:24:14 +0800
Message-ID: <20260907102414.18958-1-dongtai.guo@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <ap3IFd2FVvfKkHkV@kernel.org>
References: <20260904025101.9959-1-dongtai.guo@linux.dev> <ap3IFd2FVvfKkHkV@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: y9fjwszccteti485e8nan7ha311ti5tf
X-Rspamd-Queue-Id: 49C5040006
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788776668-769067
X-HE-Meta: U2FsdGVkX1/vaP0cgowtOzx6CUMKxfC3/qKtND91BPoO9rYqKXXuxgPH6UV8dgjrIxW7QIe+j5liwy9DLtrpWskSoiOCSvdqFzIUFVw01JPCuijQs8V7eEolyfyWNuAOdYw+xQfigO6bHukDcpx9uSDSTWiUoPS/XdxhFWloFOYT1ySqCVmLUHkHtm2sJTp2DAOkBMiTwjBUb3apVMcAOcOXwyvkflZ5+io/oHTzrb71N2sR3gBwReQGwvYXd5Zvnf4Ls0KLI5ZaHHgXroy+0NbQBwd+9FElOSrX42M3g+77bm2LY66/TxSo+ubN8oag6y7R326QmehidCaotfYpSktFPq9zuU1GMYPh+j48Hz05/gZ1uQXsX+P1YcIPmhfhG6vOCiaoc+KTvtzuRIGnew24mNLHppBx8Km2q6bdaoxYsJmrQCQ4wEAq4uXw95kMuWCshPfGSE2gqX2V1wanBMX+auwUQSs6VdmwZjaa9j+GaEjLvYoKTscp9WC3EZsSODSSoRVrYMMifIbnwT9xjThTGn/ku1s3oK+tyQzjmGSPhRa47KNksjUrg2BbeYFyuP6oK+Aa9oybGrTb3bV0ulGQkcuOYsoEbJwqoV1oKLmS9jR3EvEhP70PDejq5pSZf8wKKcDGrXignOgBBlEBUHRuFmQf6ut7ArJamjor5XvrmRYYpBj5gfUBt8RNYeHO/vK+nTNVaV0IGLkEV3RWDGlg2rZ0lJIgzN5v8ywXjlLJLNXGbui2T27jweg5cnUvAs14qHOp2hu4dRdiJatrwAIY3uQTIxTgkTtW3CWFbo0IlGPyVyv6+cPVAGi6ci/bMXRfiMycLsHdnfcnBIb5LZ4Ih4GBkh9YjRbEW/8wxcI+Y/migcwceLvh0WhBmjMWLlqRAYYv4vN1KP+wDb6xIPwn6cnmR5AnceXwFxhhTN7fygzZTELOwj4rchFWBcEieiyUyArgwBpwVtFn255
 fJtXIA8U
 bkKqgN4bx2c6IwKnJOnsRiTgliCVpMTb8I6CQ7TNNS4JNa57jHlVMyW3Qsg97jlH1zgX2GK7f1qECTTv7abz+onAySDMEuUOtHGGGumEpWzfaCVozw2a69kO5QqmfL7j7QqQ8XzXGWwk8B3DeHYu5MUVt3a2cbuwTn9FPOnUrczwL7Xzhe0i+E5J4vpT0dNYJbnuNVDbrDC/b5La790lEBcbgiaHfs2I1YWDFdwe3CKk+/8Pnyxgcp2knkDBAHgJjFdVv1xLCgdDt6C8eeSVIp9Cgaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike,

> This reads as LLM-generated text. Please add LLM attribution as per
>
> https://docs.kernel.org/process/coding-assistants.html#attribution

I'll add the Assisted-by tag.

> Can't we just calculated all the sizes first and than do the allocations?

Yes, I'll rework this to calculate all scratch sizes together before
allocating the scratch areas.

Adding Sourabh to Cc, since this relates to the scratch-sizing discussion
in the PowerPC KHO thread.

Sourabh, this patch prevents newly allocated scratch areas from being
counted in the per-node baseline. It does not address the overlap between
global and per-node accounting. Could you review this approach as well?

Thanks,
George

