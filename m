Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6111CA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 12:33:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8869A6B0088; Mon, 28 Sep 2026 08:32:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 837776B008A; Mon, 28 Sep 2026 08:32:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74E1D6B008C; Mon, 28 Sep 2026 08:32:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4F7796B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:32:59 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D2AA7C0190
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 12:32:58 +0000 (UTC)
X-FDA: 85263110436.28.9B63718
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	by imf02.hostedemail.com (Postfix) with ESMTP id DB0E580008
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 12:32:56 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=sipsolutions.net header.s=mail header.b=V4ufFAq2;
	spf=pass (imf02.hostedemail.com: domain of johannes@sipsolutions.net designates 168.119.38.16 as permitted sender) smtp.mailfrom=johannes@sipsolutions.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790598777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Iya9wujgQEdqUfmH+V2H4et1ziGVCRoqLQ6GAz7eQu0=;
	b=ZStANyMfEQ9tSldQWpR3MHPL1PIV26lHuIVBTfCAYI+ZSHA6ywJW62oNYqe4CRXlnAcqnp
	/p7SCfvVBdYpcYUciUbzpPlCGIuqt6iIyWD4sACOB0sTVbtjTBIhqjopcf6RL4bn/DhtmD
	oPdraF1U7p1LplWS7sxtqOwYXkH7mq4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=sipsolutions.net header.s=mail header.b=V4ufFAq2;
	spf=pass (imf02.hostedemail.com: domain of johannes@sipsolutions.net designates 168.119.38.16 as permitted sender) smtp.mailfrom=johannes@sipsolutions.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790598777;
	b=HUdEwRod/mgrSmKWPOHz91cvT4NEgCYrj+vF828qRxyeSYe9B6nATqIymSJ705kclub5pK
	yQFDTyAUaDgt41Ak01DfHT/ENMHsmgzWc1ODbTqZxjl5Ld2s/5Dw86MWdgIL5b0PqbxPO6
	rcAlC/kmnN+b68p94Sgi+GJ0+NnHXE0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=Iya9wujgQEdqUfmH+V2H4et1ziGVCRoqLQ6GAz7eQu0=;
	t=1790598776; x=1791808376; b=V4ufFAq2zbQRd4oAVh37zn3PzJr2yba2sbJ/bSIH7EVGTfO
	4LLOLfGZGMMkm6p+2bWX3Yj+eqGDGwnno/+HtNNSGntoetcJdOcQtFFTXJ9LviA7TRt4ufd3p43yi
	4M1pzbJTXc+Zh2qvEYox4P2ZXVME90oXtBJYvuBWXuKr46AJnsXWFYF8SvMlpWm0MDlG575Scp35Y
	rybjdINrhp/9qy97We2HJCZbGnSMKs0UBs5i5oRAXlLrbTTpIGTn381JuCJKF1eI9rSp3I5KmHhGB
	vRAfJ/sJ936YoGSRoFmwPiMrTJHiCzT5Sf9ORVad+KWt8mmJLvR2LorUG/Cjb9Sw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xBAXM-0000000DXzf-0Rx8;
	Mon, 28 Sep 2026 14:32:52 +0200
Message-ID: <8dfc0ec9ed660e373451c96b6fcc352c35a6a004.camel@sipsolutions.net>
Subject: Re: [PATCH v3 2/3] selftests: run tests on nommu architecture
From: Johannes Berg <johannes@sipsolutions.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Hajime Tazaki <thehajime@gmail.com>, linux-mm@kvack.org,
 liam@infradead.org, 	rbm@suse.com, akpm@linux-foundation.org,
 luto@amacapital.net, 	brendan.jackman@linux.dev, david@kernel.org,
 liuhangbin@gmail.com, corbet@lwn.net, 	kees@kernel.org, broonie@kernel.org,
 mhocko@suse.com, rppt@kernel.org, 	shuah@kernel.org, surenb@google.com,
 vbabka@kernel.org, wad@chromium.org, 	linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, 	linux-um@lists.infradead.org,
 geert@linux-m68k.org, daniel@thingy.jp
Date: Mon, 28 Sep 2026 14:32:50 +0200
In-Reply-To: <arpIi5QBG1_MuZzJ@gremlin>
References: <20260926010819.604346-1-thehajime@gmail.com>
	 <20260926010819.604346-3-thehajime@gmail.com>
	 <04259a99ed91f8a527b255951a6f626310728170.camel@sipsolutions.net>
	 <arpIi5QBG1_MuZzJ@gremlin>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-2.fc44) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DB0E580008
X-Rspam-User: 
X-Stat-Signature: i7mpym4rkiu3c58e5fgwce1ftmapxwde
X-HE-Tag: 1790598776-749592
X-HE-Meta: U2FsdGVkX18Out5WkGpBNC/kDkZ0p+DYoezvWaqUSkEVFVPTi8TfistLV/Qa6JXXjHoCbqHTGPCV8BBTATr68iRvHyDdW3wwIP1UwOr+Dq1bLiGWrjhVVWZq6UUoRNvW5znh7i+yblAWmwjC3MILg9n2DzhqUCo7ZgHNrOKpQ+AdHldfTm5sfIX7hgiIVhwBE7sNNEUJKi+nBShpOjeDBXcoznH+RreiecscCg8CWQiKQ7gGZGZjixrJc5JoKDHEMyNuu4t+t5YHlW/Kn/8tdBw15yATdNY2L9wt4JJfE4+500U00m1BM87UaskSeg3uuvAgzvjle/jwo7BJFlzOd0jfcNsy/Ea5tZHb1N4HQxu0LkEGweWPWMAY2F51FnJt9zdqgNR8z/+W7YDDXs2Mih7rhiL1rXwfSW19vVpcSIsrpdgnjbng1/nfBBVovc4jERu+WeY/xSurqFRSxgaMXCn9mLGRqR8HwMI9P7Wbj8nc3K2infi097tPuYejDm4+N71KzwgzG6ScW19aypniTXk9anCJGiRSkedyIwCK0knsrCPfGnDAtovKujbq70DZ6Y6ra0HZcJsS+/TbNPsnB3Clgemb4EGgdiMjx2ML+/rGT/d8BUbex1ea3Pfdc3GKZbute+NN6YWQhL35hwvmZbrpR2GnbZj/4v2mj5qGQsNNfdyKnJmTUV7lmTXzw0FzWDj+5UkdPAoAEPqXwAG4kNcdu8evp0X3x2fyyQ5Le1ho9I/zF5Tnc8rslAvnIa2ciptWF449RIPDoyILQLhr4FOdvUv2aI0r6LBviwWe3A1Mve8LWeRGO4seA+VMgbcNY6l1LvyG/HJy69krgUUm33vv65FRq35X8Xq/pPydyoXnKX2zFANIVACvgZxq6eoVyfTaO0fIWncVGVs0ms0+KNjt3MLorMUtVqB+7J6z7486LGgbbxn91B30GY8B3Rz9J40hVXFcA7TXbXlh69Q
 Fql3dJGb
 0rQsAFBkm22jJ18ZDgxZh4ywWkZ6LEZzKQ+fp7EgVxDSQvC/XRxMLk43o3qbTMDVWTVFMfpXCCDk5zJHDPsP7A3Wb4MxqqXQ+LIT4lGDlVx65uliDyWu0vqsT6i14rB7mqdtcEdAmiYuX3/7zALQbYBKtT+J6VKv9ZZatCT2wXMgBrKpZvsEZCzfAoYJJdYNGGY83Z5iDvakmJEUNbohTApsmi1XjAfxy6nc60OzIPEkUc3DcGV0QIgfQ1iPe2RD/VXfI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2026-09-28 at 12:00 +0100, Lorenzo Stoakes (ARM) wrote:
> > Not sure where this should be merged? I guess selftests would make most
> > sense, but you can't actually test it out before the UML nommu changes,
> > so that doesn't work too well right now?
>=20
> I seem to recall Hajime saying he tested this on an actual nommu
> device/virtualised equivalent so nommu UML isn't strictly necessary (thou=
gh very
> nice to have!)

Oh, I don't recall, but I guess that's plausibe.

> I think I saw something fly by that implied it might be coming in 7.4 is =
that
> so? :)

I did end up merging just about everything that was pending for
uml/next, so if we don't forget to send a pull request in the merge
window, or something equally catastrophic happens, yes ;-)

Sorry for the delay. The onslaught of LLMs means priority is elsewhere,
sadly.

johannes

