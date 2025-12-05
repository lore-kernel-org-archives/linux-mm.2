Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59BF7D32D9D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 15:07:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A93B86B017B; Fri,  5 Dec 2025 10:07:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A449B6B017F; Fri,  5 Dec 2025 10:07:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 981D46B0180; Fri,  5 Dec 2025 10:07:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 867876B017B
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 10:07:29 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 32AA1132B8D
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 15:07:29 +0000 (UTC)
X-FDA: 84185746218.07.52CE784
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf30.hostedemail.com (Postfix) with ESMTP id 36D5880007
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 15:07:26 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jTeFy8wh;
	spf=pass (imf30.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764947247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u9Sh1gr9sSQ2OQz4zUzJ40SzpPcpTrnjv9Hty5mB8+A=;
	b=e28sR/mjgAnA4q6pAwba0THuKf0VK+tfBQoPTPiDc/HPD5GiMoExTi6yxcQ8XFLapc5z0D
	C3AwblmILBSmuF67+msziXOmDN5xw8IFTsBm3BiQI1GCjDSP7lKjo7XuA7CuJKN4FqQTdW
	ASFy3msb2zFf4l17ZZ6GS1F0vEgSCik=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764947247; a=rsa-sha256;
	cv=none;
	b=YF4y7og2uK5I0P5mRoF9pZXTMTLNpC3xMugoiuI1+onB+dquQ39Ns9HkH7Ti3rLOf2WlJF
	/KmNkXavGKCbjUk95MRSwZrsgIl8sKjK4N+6X1k6JH0PzNPJReVnXj1nyrrN0Kx/+1S9Cb
	ZxWmm41RlDYdPC/BPYKY0NdhzIeI4JM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jTeFy8wh;
	spf=pass (imf30.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-42e2e3c3a83so1081759f8f.1
        for <linux-mm@kvack.org>; Fri, 05 Dec 2025 07:07:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764947246; x=1765552046; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u9Sh1gr9sSQ2OQz4zUzJ40SzpPcpTrnjv9Hty5mB8+A=;
        b=jTeFy8whGavqdveuPhlkABAqUMCvy9UN1n7tIWAd2iQwI1sUFgiKS0cFfC+DRRY8R0
         zVnjPVOKPVbUJIujmoLddZmqjb8aneZQwP51Uf3DhvYezUDMoOVmG4PQ+dIowRZQayof
         OtFmv4PTfxmVfEIk6Gl930oWp+VEATmTb8KBM2ImtNWYIxfbZMgRHOtsNZkCFqtqKK+1
         A2i0Hk0eO7HHckFAk1bfZHc+Zc7gAVLMHR1zExmsKOZ6GxgPJAwtqCmiB1hO7xYmQt4f
         ytadZyrtxzP4tWgPzgiY4NZal7iAN26/mkJmiKMzj+7vsJXpiXLmqCPQABLhBcBj9Fx9
         ga/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764947246; x=1765552046;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=u9Sh1gr9sSQ2OQz4zUzJ40SzpPcpTrnjv9Hty5mB8+A=;
        b=hfLVBqr/4oM/URcW2O9/+dbd8STqB2LbOVY+Oaw59URxhzAlWGg0ntzDqoLe+GKKZO
         +lDb8dSYvv4gJM2QvKBxLWC4kv/dN7JRKBe9REwQLnAfgYJMDoBlNLXkURvbN9bP4kcJ
         sGEjwYqVjD9EFRCi8Kc5YFP/pKAcXvAV19EfTpodfq43hmR+TopUtZcbLLortpcJjXl3
         NCj77mpQfgPE2CVXVTyo7w0lYbxhy9EErFfzFBu26vz9MZD0HinRRpkLwFEArCiMlmkH
         r1HoQDjjfSJx8n3eC56tEcOM3kcuUxVQfRNMecLe4yfQQ67L08EmsIV3U3jzM4hqb3ww
         olOA==
X-Gm-Message-State: AOJu0YzQdwI3EHir7t3IEWPwFg1gg4gO2wwLCkHXyxSvIHbBlLNkYXCb
	ga8JmVRVxNaHFZR8K9YSb2bzx8/6H8XIWU06hxO7huMpedl8uVfUM9R20gKUg+ac7NtQFAHtDRa
	f4GgUhXWWVPiLZQkWqwTJN9Ebi6ORZ1s=
X-Gm-Gg: ASbGnctN4HIcq+Vwa3MUhLxXuVBLJ+GzUf16ofkKWXVmdh0TAWHfUyAcrHYyVw9ay5d
	yGG/eWNv4sLL9gZPvxar/MJll0cw7RnKwIHZwN4Jsq8IURfZ0CTTakgPLcLTy+b+D/5GzGG8Z60
	B1jxTaj68GLk3gF7NxiiiH2/FqA/rmyMutvXLhcOtODQawOAtYQGbfBc4VG8hJC+ySTkY51+2pw
	y9PtoFc5AFpVyL3KMFAg63j6DhdY/TiBiIFa2Lv9rEtDniaTkoNDwuB7Hr6PpuLv2sLbf7Jv7vA
	TaDcV6Fg2OF3GqnTg4vvY5JTWV+GYVqlTw==
X-Google-Smtp-Source: AGHT+IFPNstD42JyEsdAwcyvNzKrPqWXxWF88WKwbukJxgV5AcHCpundKVhQRbFA20xriAn3ElLB1BNzDwQJkxHjQm4=
X-Received: by 2002:a05:6000:2c09:b0:429:8b01:c08d with SMTP id
 ffacd0b85a97d-42f731bc24dmr11041756f8f.41.1764947245574; Fri, 05 Dec 2025
 07:07:25 -0800 (PST)
MIME-Version: 1.0
References: <20251128033320.1349620-1-bhe@redhat.com> <CA+fCnZcVV5=AJUNfy6G2T-UZCbAL=7NivmWkBr6LMSnzzTZ8Kg@mail.gmail.com>
 <aTKGYzREbj/6Hwz6@fedora>
In-Reply-To: <aTKGYzREbj/6Hwz6@fedora>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Fri, 5 Dec 2025 16:07:14 +0100
X-Gm-Features: AQt7F2pv1BpZjdGZf4uiwOOKMqx6h_y-AphkDn6MuXmCXnyvxBMukG84fsup2wA
Message-ID: <CA+fCnZewpfDzdo51s6eGPzNohdQ6xHkBwX-Sxo1qty8pBgHZ4w@mail.gmail.com>
Subject: Re: [PATCH v4 00/12] mm/kasan: make kasan=on|off work for all three modes
To: Baoquan He <bhe@redhat.com>
Cc: linux-mm@kvack.org, ryabinin.a.a@gmail.com, glider@google.com, 
	dvyukov@google.com, vincenzo.frascino@arm.com, akpm@linux-foundation.org, 
	kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, elver@google.com, sj@kernel.org, 
	lorenzo.stoakes@oracle.com, snovitoll@gmail.com, christophe.leroy@csgroup.eu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 36D5880007
X-Stat-Signature: i1th5uzqhji5q19rmfa54kkgksa9x9c8
X-HE-Tag: 1764947246-205392
X-HE-Meta: U2FsdGVkX19XC3SH09dJ8iIHmqplCXTLQJsTPeEVnPuuoxzDdyMpv0VOacmIc9tCDKmoso824VBOICFeT4NNSsg682727qEaoeETtt/JJWnOHtmlPMJCCxnbx5hdK2DIDKXfTeP5K9vVGdTD9TkHr+O//sQtJbmITJwMXLtp8ecOX9ZTU+HV8iuWhIt934Ukvb2G1Hcx6t0NFhpESKuTArCd+xLPpRvEJYLgc+EWYsr+PPYiqGAsbFV2pRrES835MaiFNucfggiGhrOXPRqHzOrOli98oGVtPKZiVp2mGqv7++9yGOnFbJdD/fhSVlvefsVMFBXwp8K+v+uDZVgHYrczrkhG1yUe9rrHabXVHY+fBGKVogM/TevHYMMAAwevAg+dAqKCndr1Gm/111a36yQpfl5N5Lnogf+lhmd8CUIHSDWR/4FijDk8pz+6pES9yc95NBbqL8IaEL0SsBFMEz94YFQpqOvqfwxbkYzELbiAz7n4Gt//xmb0/AQm9BukxLT6AsdcHjVbjA6DVM8qHR/Jhc+hMIxC6VjQLI57SluEmnEQcb5QUI8qpKS6Wpz2CdpjWGSVTUGxuh9sePzgtSWVIAD4XlkbbfXa+l9e8MKmRwOg/HXJOXl2qJNFmlaA1TSBBnzeY4ZufrzLomsr5Tr9vlAOHqj8pLhMhh2wYn8Y2UfI/W6GI5cLu8AdUcJ09yNTYi3pLqbxLYH0D38AbdigW4FlVufIwtmI4yt1rNWDMKPrgC+Pb9dLRGzg6RoEoprJZhMs2VXrp5KFGEXEq9wrnbFdKFSbjLpX+kcVc2wW7RHoL6FjVSWt+dgm3DXMVw0XkM+Hg2PJJBNkZtn0De56Ywd6fYGaZwxYdfpKOFmCwH35e+hJhuSS826Jjlar95+PTFIwlMRIlyaFmieOiMYwrcAzSvNtOVJ9Ts68Sj69GdKJbQzZpC0Z3mM5ffMzEuxuEEUD2/9fPrYlotO
 zejoL9kR
 14gpNfLJ+HHNTwMc5e+VjmGLeMhAENrYwC4pdp7ODoRW8qG2Tg4ge228U0/F9MKV3+vquQNW3+1bm2iqO0aIls24HpnkdG+XPah2xdkiBnEXxD63pTy5h7hgrx5x8WN3HJPLKhsR2kC72p+Kco2Jmy5PEoB0Rct3CPqgNe14z4vnS1CJMfBWVMRA0zZNWo+S75feZfrTzsBU3NtHFfvUmySXBqHGKM2vkibivcJqEsEpzHzIaTBy9QhtWlriC07uygAwjPRdb9oe/cpfNwJmdav4vvH0rNPc3I1QRziWmdRiGUbnuy93kukQacVelReC/XigGeSEvDcODw0JfkucIyGDHghZAUMxWqyJmNiQQMTXEYeBqrFOnHu70+o/aPsoLwtIjSn40v6aWStqqBOlnDGSRAqcFI9f546MOtVhXlwmOxXMMiUpxFfq3jH3RnPWvM4Cd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 5, 2025 at 8:14=E2=80=AFAM Baoquan He <bhe@redhat.com> wrote:
>
> > I also wonder if we should keep this kasan=3Doff functionality
> > conservative and limit it to x86 and arm64 (since these are the only
> > two tested architectures).
>
> We may not need to do that. I tested on arm64 because it has sw_tags and
> hw_tags. And if x86_64 and arm64 works well with kasan=3Doff in generic
> mode, it should be fine on other architectures. I am a little more
> familiar with operations on x86/arm64 than others.  I can manage to get
> power system to test kasan=3Doff in generic mode, if that is required.
> From my side, I would like to see x86_64/arm64/s390/power to have
> kasan=3Doff because RHEL support these architectures. I need consult peop=
le
> to make clear how to change in s390. Will post patch later or ask other
> people to help do that.
>
> While there seems to be no reason we don't let other arch-es have this
> benefit if the underlying code has paved the way, the arch side only need=
s
> two lines of judgement code. Personal opinion.

OK, but it would be great if the arch maintainers could review and
test the changes.

