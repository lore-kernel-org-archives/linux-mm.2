Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAE49606A32D
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 19:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=readahead.eu header.i=@readahead.eu header.a=rsa-sha256 header.s=fm2 header.b=ag2Z2H5T;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=WbCGlWg/
Received: by kanga.kvack.org (Postfix)
	id BCDFF6B05B0; Fri,  6 Nov 2026 14:46:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B57B06B05B1; Fri,  6 Nov 2026 14:46:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F9316B05B2; Fri,  6 Nov 2026 14:46:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 755C66B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 14:46:43 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 078471401D3
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:46:43 +0000 (UTC)
X-FDA: 85405726686.02.5388ED7
Received: from fout-a8-smtp.messagingengine.com (fout-a8-smtp.messagingengine.com [103.168.172.151])
	by imf09.hostedemail.com (Postfix) with ESMTP id 84E4C140007
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:46:40 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=readahead.eu header.s=fm2 header.b=ag2Z2H5T;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="W bCGlWg";
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of david@readahead.eu designates 103.168.172.151 as permitted sender) smtp.mailfrom=david@readahead.eu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793994401;
	b=OSfzPEZQG9kcMduOEmixXkPOMEdahzR+0AZ4sBDBt9hRKfyKIYuu9ZbUmgGysxWBfX6ShF
	7w1J6OrMQskc/tIsKb4G3ozwa62PY4WaQY9dNUzwWf4lYJvpalxhSmup/LOnB4zUFtCFTm
	C3ls2CTyLJiVoZPPTaoLLlLopnzrx84=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793994401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qhKoxva0JL+l8sDegVq+F6O0qeFNZ5Zg3O8huHi3mM0=;
	b=Y1kKCB5MAVTApDNFJP4rTU0ga9ZPvd6T+ItQfZOlvCUypkIiur4RzDbBMKpRI6wR7DPYJ+
	GEgyUdZMcpKeaT/Gwh7Pm8C1CJx0HZpqT2u4AjcmbJ5kRgRu4F5Ksv2STlo9EZHcigT4YF
	ywUXbE0S/VYCh1ozsiYBQV3ZXHIYTjU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=readahead.eu header.s=fm2 header.b=ag2Z2H5T;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="W bCGlWg";
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of david@readahead.eu designates 103.168.172.151 as permitted sender) smtp.mailfrom=david@readahead.eu
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfout.phl.internal (Postfix) with ESMTP id 9EB53EC0862
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 14:46:39 -0500 (EST)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Fri, 06 Nov 2026 14:46:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=readahead.eu; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1793994394;
	 x=1794080794; bh=qhKoxva0JL+l8sDegVq+F6O0qeFNZ5Zg3O8huHi3mM0=; b=
	ag2Z2H5Ti0ErRYro1uqfcVsQLshlA3jWD0g8g9qfGfL1maXy5+q4FQU+jgyev3Xr
	RmtIbH6AdOVvGyanXJgpIAqFbz+HctLRgRqb2cxdEMJBw+g7IGde9jH3cF5IZ4BS
	Y3hJI/WSOc2BU8CyYXbN9Y926BZpWa5mdfueI1iHhOFJCAFIV///2ql7AOGUaEaj
	cWinNQIUfZJ8dyaGWTfd7Dv+AA7+TEm8ejvwGKg/1tm6gnYLaT79TLq2YHnAMcfC
	6JkAwoenbKTif6dCiwPllfWHuirkaa/EyQNr0ddZdYIfhMbG55cmUrENHR6SphaO
	LGxLpAGEf063GBZ3w+1bGQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1793994394; x=
	1794080794; bh=qhKoxva0JL+l8sDegVq+F6O0qeFNZ5Zg3O8huHi3mM0=; b=W
	bCGlWg/gc/GYzyDYF9V10w76mEB4pXNz/yllOVx1JvJoN042i9QLIyYX/psmtdl7
	0mMcTbGqK8N4kR3F+OH7pLAXB8BRgaDH5S9HvFsvvfnIwql9m5unLub7LujogHLr
	clPb+t3TaoO9NIG+433gs3xpu+eeY6i0Ol8PbQ+R9/3GqohjaX3nk4x+2JcCbzoq
	ZQV16IUS4Hcz6J3qC7Nxkx9OwQvSym5Lw5gMrxGV5COnfGQwzMeKJsR4gLQjYPWp
	O2MIbF8H0WyQ9ZYpsmnsFRtLlkdfFmsRbW7WLmJE5zR+qyZx3dabQr3OFYpJnHpB
	sf1uW3Z+D/bH0eYzlFRCg==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=readahead.eu a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793994394; d=readahead.eu;
	mf=PGRhdmlkQHJlYWRhaGVhZC5ldT4=;
	rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm2:rsa-sha256:HOQ6l87gAvDtwTHH0+qU/8eM4CPlkO9COIOOUoWWuY8wdLe
	g25aRBuJqPkmd6gYmBTujLetfJQGd5Gue8cniql0CikTLWVd+f7LK3ZWyzSJLJHj
	+BTNxkw8dbPdYwkjwol5ANliwGEqfMoIdIqP/O+rwlUWLsTXPBCCzpRoo/0vZrKy
	FOyXbQg2a2cI7/QyI7MXtwVBbQL8XymPc0pJJMi86BAPVND4Mty+Q1uDKYWghFSg
	A7p9t7nyXj1w7efGFFCUytlYXZ4cTQL7eHH/nCIc1lS1op6H1b4a22YgLEcbX3y0
	+Di0XiHPuQdVqpo9uyWhyRijbrF/ml2r53h9nSg==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:ZXYMNTvVJSIN7d7nypu287vHLlCVFtx1p+56iwTdm2U=:YVR9YXua2pXGceoVU1tO4HWt1dT9IBqHvzi7bV/+K30=;
X-ME-Sender: <xms:lC7uaiy08CXPYJX_-oMjkrCLTLCvz_9vEVHdF9JV-aQZcfo37H8XNA>
    <xme:lC7uapESe4X2r4-9tbosgocOP3mUXBiaG6Bj9W74leR6UsXMdR3n6Eh5MK1FctiV_
    4aXtO1rwrCdNhwcwoRbxa0hkth5g0M9jTk4fJm5CUfFqHk-VvXgWvAM>
X-ME-Proxy-Cause: dmFkZTGUo7IC6fGRL1KVNl4H3kKPTqlVG3UIT2AdgMMD6pZ2tEb1YktnY/FHMj6Q5TyF8S
    4cPLg+L1p6KVN+PKIKLa6P18N3Tuw2cahYHmZHUQ59vKq9SJUxlw8rmWe8DXJXQOEdLs99
    U1c0jX4tkCS07Q0pBU2hQOzLWuCpnoF4Sd0SbE7swUwx5nbO1uIuYHYE0GB9cxqJZA7jBA
    ULB75RlnzHYXaUIAVbS1kVKhGBdzr4ZFrGFbJNXjXJ1aGEpxmH0KT9naxZ1oH/T9jP7xSn
    /fzjAAPjNRojDUct0j6UDS8pDqdDK/UomwyxVtV7L9toWyEJYSSbG3S5/2ypOIdY4MwKtZ
    zybKxSTT2yfOBX70vjqtGwKVX64NrDMFqeC41H+O0uIQs+9wiD5N/uhoOJMaWHvR+EKiY6
    YHkVId0B1PrQCuC7nx9cDRHeeoWvietuEokrqBrkTQqAJwxKKXFmh1z3z+H2vqV7F2GASI
    5plmwvEfFKK4eo5WPkzpnT1vFb7nyV3ZrujVNdKexZadm3uVVGZ9UMJqm5tuUO6nHxj0Cr
    GVlHaDDpANsqqxyHdZgXD2eQ1Dk6VBv3M9i+Qk1Gi5axtYWjPemSyXSegoekVDREJpCoT0
    jYoIyDcoQAC+AmkdsvXb32LmtX/+ZqqjHYrqVtWUxGdLWvhAgu2ETjpuapPA
X-ME-Proxy: <xmx:ly7uakESJVpTbvlQpkTh3h5TN24Pz9dEfjXw7iokr1dFh2XQxmj52g>
    <xmx:ly7uauvCNUSmqjbus2WAkxD1WNAAR1RN3n0DsZT28DNv7BMUh31tYw>
    <xmx:ly7uanbfXW4c8hS5uy24KQdRDX_10cYgNLfvTiFFU8tcwsozohhIVg>
    <xmx:ly7uauXfeq3jiR0atVVOrlAPquBYDiD3JfUAjpDggUaVAxH8j1M1lg>
    <xmx:mi7uaiK-3bDIvhGZDRgh3uzguemoevRUSBWP3S4NschLy2i6ZmjxcjxM>
Feedback-ID: id2994666:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 4F08A32A0097; Fri,  6 Nov 2026 14:46:28 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ThreadId: AWOKgKtlazLR
Date: Fri, 06 Nov 2026 20:46:07 +0100
From: "David Rheinsberg" <david@readahead.eu>
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 "Hugh Dickins" <hughd@google.com>,
 "Baolin Wang" <baolin.wang@linux.alibaba.com>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 "Vlastimil Babka" <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>,
 "Suren Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>,
 "Jonathan Corbet" <corbet@lwn.net>, "Shuah Khan" <skhan@linuxfoundation.org>,
 "Randy Dunlap" <rdunlap@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, stable@vger.kernel.org,
 "Chris Mason" <mason@kernel.org>
Message-Id: <2c95ecf1-058e-4d81-9de5-622e32dc57df@app.fastmail.com>
In-Reply-To: <20261103-fixes_core_2-v1-2-f332954f1df4@kernel.org>
References: <20261103-fixes_core_2-v1-0-f332954f1df4@kernel.org>
 <20261103-fixes_core_2-v1-2-f332954f1df4@kernel.org>
Subject: Re: [PATCH 2/2] mm/memfd: handle GUP references reliably when write-sealing
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 84E4C140007
X-Stat-Signature: b6ed6g3m6qhmj6shge8jw5ici1iqqdag
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-Rspamd-Server: rspam12
X-HE-Tag: 1793994400-806873
X-HE-Meta: U2FsdGVkX1/t5mN3zIHrboIu7xHMvhd1fmfBXpqNCbgfvTirTGY3Ve3i8wGLAefLvDXjod/cUZgbRoa2F25PToTA22Ovpr0PUoRznP53wkzDexW9VRKunELDMJNeZippdueHB01d/SpEAMS6jNWV1WxIuo7MDCmZFDlYBnMVHYJRtsz5IYq9hQj12GcfK3RFp6N27vjzovoHBsPTKTtqvtt8PYHYIpyC7CnRU9NAvmpnOr8Z97KO50MGdS73TpXt2KXZvFQGT6ndqAMYTNYX85y5oZG5WUc1palfOzS3tKwLHBv7819WZIm6XshvQ83I99vySAggzjLTU21XaZChM+MB9L0C3P3UBrBIy2VIv9WTUQXF7uZBv4mxnxbTWaz3NCh7xNz8j+xvvXvnHwtEDooKMcS/Y9CtW6Z20+ztQVBASt4s4iw0oCTRjt/Yhh7RYYWD6XfoXJNnICfnlj5HeMEahckWF5fMJ7gr1RL81e3ju4CFqxSb4jFZ/a1sHJX7nKiWlfaRjVixhWO5Wb7VIouCfk/XQPkd6M6INgZDaDveya07nyLrL5cP+4WCRUtKg5jaTSNT2fTQma59GJ9r5UnHHyfnpDB7HUooJl2XsmuLRMlrX+E+wZTo0YIX0j2toA9vOlhcvovppYMD2k47c3zVgPHJkszRG8YjPwqGyap/AC5/T0x7Jt78Eie9mjRlOXfUM7PPchfvbyMo+3LBz3U6rnGuFqrKoTnh0sRZgRaIEahS+d5UkKOA9lkO1SwCiLDTjHdHkc9pBDkMcHlsZ1WB2lHg+98+tKwkN+HljIz3QCoupVGslooPsFxI0r1bhXpcYbK7Tu9iUBjYKVYvLCTiFd73JjS8SOfR9QLXbusU4CwS5bANmIO2i1wNA07fCslkeZlT7hL0ejYX+uYvi9JpPb2haUR2VGPfXJvnvJGbH7ni7k9q3xF2ZZHVIjLZTxWqky2kAbiq82nUt9c
 fPKjx4EH
 u87OHPZR3XVkGN/iUTIjKaDaYv7jKa2AHguMjjO2hkpcz6lj/JAkBfBeWoOqGIUcI5P7lFeiNwEv32FqThevyKr+ZuQZA1bUI/xMhIyVpa9tJzpqSBMCj7P2ZTP9bzDPiz+bcJZWygPetunJcebJFPKYJnEj0fbeti8f6JK/k8d092ktz3QG8UxzSAifPNqZO2La2VMcb1+8aZY75JnDa/NQS+cMrKf5ILFGvdKaDyhg+XStb6LsWZdUKuKkmtp8i311c/qe0GVwrRobpGIvgjgkUvvK8VupopdLbH6yuzCOxsTk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi David

On Tue, Nov 3, 2026, at 7:31 PM, David Hildenbrand (Arm) wrote:
> We made a big mistake when introducing write-sealing: we should have
> disallowed *any* file mappings while we are write-sealing. Write-sealing is
> usually done by a producer that wants to hand-off some data to a consumer.
> Having the producer have a read-only mapping (private or read-only shared)
> of the memfd while sealing is rather odd: it couldn't have been used to
> fill the memfd in the first place.
>
> Most identified public users don't do anything like that: they either never
> map the memfd before write-sealing (using write() instead), or munmap()
> before write-sealing:
>
>  - systemd's journal writes, fwupd, Flatpak, runc, crun and
>    containers/storage write to the memfd without mmap'ing it, before
>    sealing it [1,2,3,4,5,6]. The FD consumer will not access the memfd
>    before sealing.
>
>  - dbus-broker, Mutter, Chromium's Android linker, KWin, Weston and glycin
>    map the memfd file, but unmap it before sealing [7,8,9,10,11,12].
>    glycin retries sealing while waiting for the loader to unmap.
>
>  - go-memfd exposes a shared writable mapping before F_SEAL_WRITE and a
>    private read-only mapping afterwards. Its API explicitly requires
>    unmapping the writable mapping before sealing [13].

When I wrote memfd-sealing, we had this use-case where an application writes a buffer and then shares it both with in-process and out-of-process tasks. Only if out-of-process tasks are actually involved, the buffer is sealed. Otherwise, it is kept unsealed and can be recycled. Hand-off to other processes was optional, rare and asynchronous, so sealing could happen at any time. Yet, we wanted to keep the buffers mapped to avoid costly TLB flushes. Mappings were readonly, but writes were done through syscalls.

We still do this, but I don't think any of the open-source users picked this up. I did not follow the folio changes, so I am quite unsure whether the implementation was racy from the beginning, or whether new infrastructure introduced the races.

Can you elaborate why folio ref-counts are unreliable / unstable?

Thanks
David

