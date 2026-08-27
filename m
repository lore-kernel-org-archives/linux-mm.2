Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01AAEC61DBE
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 01:15:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 076FD6B008A; Wed, 26 Aug 2026 21:15:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04DF36B008C; Wed, 26 Aug 2026 21:15:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7F266B0092; Wed, 26 Aug 2026 21:15:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C66FC6B008A
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 21:15:57 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4023D1C17B0
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 01:15:57 +0000 (UTC)
X-FDA: 85145282754.23.1F55461
Received: from sender5-op-o11.zoho.com (sender5-op-o11.zoho.com [165.173.182.11])
	by imf14.hostedemail.com (Postfix) with ESMTP id 34648100004
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 01:15:55 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=SZxuyygq;
	spf=pass (imf14.hostedemail.com: domain of daniel.almeida@collabora.com designates 165.173.182.11 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787793355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vzFV4YTSoIcUz/ANNnzBojGs8mxChDWT8nd+V0Zczo4=;
	b=1qa8LvAUHiooHOO5jxkDm49brDFOjyZGGH6o4sG4Dhl3OfcWN/6sthWnPPeujImqeAK/IP
	tqQdny3EzYxnYeOwOiR2SG47F+3Gy4LWHOD+kUDNodva/+embarOJVROFSUVnNvlJUxYJj
	874zbJE+loT7YWGi9becaNaVYnDlPts=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787793355;
	b=m601y1NRkX1q7PP47s6XU8Vc6Mds1ahAvouSN3NGcE7ev+ga6AXmGjuy3rTNXIVRFMm79M
	hzOPr1t3NDl3TJtLHba+brfp+f4hQxKPssTZU0xflen0L4/amFU37PW9xhV9gPIJhtr9wS
	OO0U6175/M0RN+kZ8vKD8ilJ6OKhS94=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=SZxuyygq;
	spf=pass (imf14.hostedemail.com: domain of daniel.almeida@collabora.com designates 165.173.182.11 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Seal: i=1; a=rsa-sha256; t=1787793318; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=fKdwSOAUoLaixMqmZrWrRHFKQ7HX1xX/JE3X1k5U7zKgj49aztZP5Jco3uApED/bsc4Dsd/oIY9rWjp2uHi08UXPeqH0j7wRMHmELViQ1x+iOiuhCphXPWtLOMfwE8gNk2+5R488DHg+1nRco9CobimtLaNul6xnRXgm9dJZv8g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1787793318; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=vzFV4YTSoIcUz/ANNnzBojGs8mxChDWT8nd+V0Zczo4=; 
	b=JS++cG25r2E+wjyyouXRCyKaiQLx+J47y7xeh8jJNKW6XhbYn1CEpzRfEn2IZbZi4QYKJP7Ssn+Ppc27SDXkpUgjIvTkHiSyztl7io++J20wzkvTCtqEj8UxmH/UjzDzKde7Y5xiE/KKuIXbWvdScaSMIpY18KFGqpYmOuz50tI=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass header.from=<daniel.almeida@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1787793318;
	s=zohomail; d=collabora.com; i=daniel.almeida@collabora.com;
	h=Content-Type:Mime-Version:Subject:Subject:From:From:In-Reply-To:Date:Date:Cc:Cc:Content-Transfer-Encoding:Message-Id:Message-Id:To:To:Reply-To;
	bh=vzFV4YTSoIcUz/ANNnzBojGs8mxChDWT8nd+V0Zczo4=;
	b=SZxuyygqh793azRppG8fjZ0fz4hiSQEiLf46mjV5aZrWjT8l/0H0oiTUngyK+Evq
	Regx3dICNEyO+pPp91hwkc0+F55lQdk8kCDxJ000aeBxl8FrSylYSVCtShV4hM8U9ZM
	x0R3QTHFr1zk6bzubgRXAHX66r8+EHb5NSSHofZs=
Received: by mx.zohomail.com with SMTPS id 1787793316273765.8792330306574;
	Wed, 26 Aug 2026 18:15:16 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81\))
Subject: Re: [PATCH v4 06/11] rust: xarray: add `find_next` and
 `find_next_mut`
From: Daniel Almeida <daniel.almeida@collabora.com>
In-Reply-To: <20260604-xarray-entry-send-v4-6-965f6028790e@kernel.org>
Date: Wed, 26 Aug 2026 22:14:56 -0300
Cc: Miguel Ojeda <ojeda@kernel.org>,
 Alex Gaynor <alex.gaynor@gmail.com>,
 Gary Guo <gary@garyguo.net>,
 =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>,
 Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>,
 Danilo Krummrich <dakr@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Tamir Duberstein <tamird@kernel.org>,
 Boqun Feng <boqun@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Harry Yoo <harry@kernel.org>,
 Hao Li <hao.li@linux.dev>,
 Daniel Gomez <da.gomez@kernel.org>,
 rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <BEA4B094-7587-45C8-801C-A6F49E574EA6@collabora.com>
References: <20260604-xarray-entry-send-v4-0-965f6028790e@kernel.org>
 <20260604-xarray-entry-send-v4-6-965f6028790e@kernel.org>
To: Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: Apple Mail (2.3826.700.81)
X-ZohoMailClient: External
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 34648100004
X-Stat-Signature: oundumww1amh9r4rwui3uhp9zcfw9nhg
X-HE-Tag: 1787793355-267840
X-HE-Meta: U2FsdGVkX18ysunTz4t46IP7RUIlcMyl3r7xD16gxw5uqy1/lqBvRXCtx73vKYJqV8ZM0eW+Ig9upkp/AZtegk3Ni++m08e64Co2yFcT+hfO5BrGBZSve0U/LFCGzmRuCzIb7rssDK8+LB4UmFvF1UXB+zziVM2sCP3Mf3gsNmY7X/bIp1Qfo5QGPXgxta3zD83Pb1WZMTJEN2xlk2DAdXNVBunR38iXVAei8mrldQEFxtrOq1qOYFAIdweyw1UgcLv6Qg5JC8kFx9wxkSdp78X9eul1wb/4dm3UHsJBy9uXo8JPzgBhqrjDLQXZwe25rlMRYYVmmD3Ah2EpaLp8DlTriq90azW4KvVXBYexipw6o69DSqV/fpspKoG6Lc4+VZWZh/ayjaFevm9s/mQwTCYQZwc+pk6B9IL/BjUmlA9HWYpPH5I76U4X7Dl+aBrvGgW+dQQi2EBw+gktIYSWEvSL8CXvrs61bABvUfsUYnYiHe7woiuaDnE8UrQjKJfgIpeGp2cJ/W+ktxInOVzafaffMUJ8iIE0tJ6myka18j/8eKnTYYGc6uVNRMWZxYyLpfhOAGeURs5aQmAy4MbyqZpTPGqVK6hkcz/rg+iFXlkDCLmZZm4I8wOIddI2sQMjzT2EcBOjEbd35lBgG1zYO34/Di32vwpl5JJakItAT4l3kEjK+4I3UnoUuSV9VTxf3osbvSvxhIv3u8iQ0h9ISmqbnjYFj1U3Ys5rjFLbs23ZeuyFMMbZhoapfRhBg3gDZ7zea+8XunOlOsaLqIJxz4Cgsh89Q+oTjflql1+nJ0eiWCcuMZCCHDa2rsHsZhb5K4ZZUW4GE2zQr7KK9cbEx70/7EsUejiHvBObcTEMDLi7tMSyuD6EE6RMdzd5ytdvgAWtkUoYvNBfuDgYuOIfyYxPDYYK9vCnEsGvUBgAIbRd4wEvEhodC7Tu7aJwzkEetirKMV0wSDNyoFvLyUT
 T2w8sayI
 T2d3EHyICB8tA49iixccvCZwdV1mNdPeTx0tIAFi2KtRbsH+xNs5/mYkfjkC0IrbG1P1EZ2Q6gOromzVRQIfo1I0a2Lug5PnuJYE2tpgIVu4MDJdUs4OVv5763OvNFky4gPV83ZwpT1K/IEP0pvwPzIO8T2OC7YxTKnLihcvIl8DJWeVCPbKUeHqj0bDzy5vP6U48hiwlqVzkPACDJknjFrDBpLsp7mX/ZdBW68nieg+KBHin0JicAb4+tcgox92tZ1JpKy/sHtgRXiodhG5niWCK88OuPG+SpDCO1w4L+tJ9SYAGF/M83CA5gxtD6R0zDJizjFn2EsegUXwmGEhEyup+Umd7zKG5Il4Ornak0uHgeFVZ0jot2tormu0uwuhlkaP/4vn9NiiE97ydwxCxQX/il90DlBqM5cIcOwVcji6OU2GVaxLzCzDRJsuiKhuciRTxMeB9zvJ9NGx8DvtlYdsEobHZbMZNdKeXauAwLe6yA6hRLUYcz8fKrw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andreas,

I wonder if we can't hoist most of these calls accessing =
self.state.state to
the XArrayState directly? For example, I see this in a couple of places:

+            bindings::xas_result(
+                &mut self.state.state,
+                bindings::xa_zero_to_null(bindings::xas_store(
+                    &mut self.state.state,
+                    core::ptr::null_mut(),
+                )),
+            )


How about XArrayState::replace(new: *mut c_void) -> *mut c_void?

Also:

+                state.state.xa_node =3D bindings::XAS_RESTART as *mut =
bindings::xa_node;
+                state.state.xa_index =3D 0;

Could be e.g.: "restart_at(index)=E2=80=9D.


WDYT?

=E2=80=94 Daniel=

