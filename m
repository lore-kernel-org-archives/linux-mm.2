Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E103D2F7CC
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 12:57:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8788E6B0152; Fri,  5 Dec 2025 07:57:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84FEB6B0154; Fri,  5 Dec 2025 07:57:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78D266B0155; Fri,  5 Dec 2025 07:57:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 672B06B0152
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 07:57:37 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1C0C51DBEB2
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 12:57:37 +0000 (UTC)
X-FDA: 84185418954.13.625636E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id F33098000A
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 12:57:34 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=b8abERv2;
	spf=pass (imf30.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764939455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bHMFmGN0oadjbgXe1sqHZFT+wgMNJVQ4LPoHUYfdTrw=;
	b=HU4uR8ZX5lQQnsksrafg9ed1PVQxbRapU6yPvNiBkuR9etwbtaBq56kwkIq5EwAiXqqyL+
	MIInS7J2RADtrgBi3jQeeH8PhOSx4RJ8Q/W9TBjx9YAyLrbDGshZ1T+NQhk5AJU/EIZSir
	096Ev8BafPnI7HLkvEaT1GzSajuvFnw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=b8abERv2;
	spf=pass (imf30.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764939455; a=rsa-sha256;
	cv=none;
	b=R+V+FBLwWXUL+PrRocsBEFPmZQpKJ9E9dOKiGEZp8oMY2j2TfUN2aCqcmYhqwq9JL0UR8h
	sPApEyect+aiCzNO3YAXdXlATaPUGgnYcfWS0aH8EE891poIQ6EwSEI5dfiO/F9sqib43k
	e2Gii/KzpgaO73UhFb6c9GmqsZ1iK38=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764939454;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bHMFmGN0oadjbgXe1sqHZFT+wgMNJVQ4LPoHUYfdTrw=;
	b=b8abERv2u+zo2WReUZhm2+PwuzIkKuAoJCOM0T6CqKjeawZoF4ilhR7IUEsG0ZGf6JS4OS
	TYo0U6YqOy3sdnFOsAKWH5GSYptVn8ICkMeXFQeR89uUMq5audRYxUB5w+/tF6NByC42P2
	e/lmmY2riFcQlzEaFMNhnSutNyzTXCo=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-454-zVsvedK7Ppqdvd4IfslGNw-1; Fri,
 05 Dec 2025 07:57:25 -0500
X-MC-Unique: zVsvedK7Ppqdvd4IfslGNw-1
X-Mimecast-MFC-AGG-ID: zVsvedK7Ppqdvd4IfslGNw_1764939443
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4505C18002C9;
	Fri,  5 Dec 2025 12:57:22 +0000 (UTC)
Received: from localhost (unknown [10.72.112.52])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6FB9719560BE;
	Fri,  5 Dec 2025 12:57:19 +0000 (UTC)
Date: Fri, 5 Dec 2025 20:57:14 +0800
From: Baoquan He <bhe@redhat.com>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>, linux-mm@kvack.org,
	ryabinin.a.a@gmail.com, glider@google.com, dvyukov@google.com,
	vincenzo.frascino@arm.com, akpm@linux-foundation.org,
	kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org, elver@google.com, sj@kernel.org,
	lorenzo.stoakes@oracle.com, snovitoll@gmail.com,
	christophe.leroy@csgroup.eu,
	Mikhail Zaslonko <zaslonko@linux.ibm.com>
Subject: Re: [PATCH v4 00/12] mm/kasan: make kasan=on|off work for all three
 modes
Message-ID: <aTLWqo03FUqN3QKz@fedora>
References: <20251128033320.1349620-1-bhe@redhat.com>
 <CA+fCnZcVV5=AJUNfy6G2T-UZCbAL=7NivmWkBr6LMSnzzTZ8Kg@mail.gmail.com>
 <aTKGYzREbj/6Hwz6@fedora>
 <20251205110311.11813A10-hca@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251205110311.11813A10-hca@linux.ibm.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: F33098000A
X-Stat-Signature: anfooemtur158mdkynrr3n93nnfqiigk
X-Rspam-User: 
X-HE-Tag: 1764939454-388117
X-HE-Meta: U2FsdGVkX1/QNVcHzP8LtjHy3sAOShgFxQx1oKRS9iB6W8vFl6Bd3Cb1jTA5ksMTVowERJC+lyyxU6x67EKKwu5YOxSa8YOrIKVMXPIMSTD8vYbS9edeaZenXIKXu/52nqCsGcddNrcvnGj3mjvLIJFPxlNl8hiYBcitfbPwmrRdRRKeriSSCv9q7czE3pzPyZ8Q14VrfX6/9B3v/dIdCdyzvz3J+8l6vKCxnqWxSuzBfg60YR06oOqQ1dlQXlOCvlEmphsapDRNva7LVgKDadfXfKFjv/WLOFvAqAflOWJiYX2uRxuwla3b4R4iSmZmYizaSmzfRvrrf65DA4R0wSE1YNePdxXFOsi0rPJI8vNsOBezi+OF0+vMlS33aqr4ddH7EZ3VjHD3hwuSv9ACZ7ZIkty6jFp7QTPSVuyIcfbMBoOPDRQj2TBj9orjhNr3VxhYrILN92Pchvhq18lBdfCocJNIFaq9wtHdFcGqFSVr2JXp8JLX3m9kGppv2csm2dFvZOFhManzcVMVL+xjc4Bdav5/oOyDhCqrEnsSZskrCtkd22E+OjHKDlecpBPmkj1sStGqEDpTlUrt0o3C9npg6eZZ23dTSEg/05oqB4DkTE6PsxmgO7oxDAORr/v9lrTXPhV65y0ME0bSX1mgAMfbW9J93s2riQEM31gdwxBT0Zklke/YEaxwHP3/V84Loe8f4BxXCWOxmYV9UTh5EixI1ZN7tt1d7r7xhCDeddP9SgZVTUm2aTqDAsfr1/Dxby9Qa+09jY6Q5kGeRuQzpHVg1WZ9HmbeZASkhL8mcCXWqrE6Rc+hXsu41PZgZNjjjyGyNr7mnbxM95GHlz9U4o/cwVcZ0F+7EaP9al0jVbW4hEfaY0cz23T0Q+CNDDBZY7+Jg15oVAGsbDjmn1QcKGIiGFlWVxF5Rxmsec/gURDl45AOI9hGyRpshMUdweDnGr5Rj4sZLozDy9zSaAy
 PdGyOrht
 o5z+OiyVqWtO3fqP/p6zWzQoHesaY5KagNdOUGESRZUXhHH5TtfR+cxxLiijWDMPBgAsAfKR6H/OHemOlshllWZqh46TFP8J39QKQoCiNnAqhXyBkcanTl2EB0DWUDbVXvOjKtdjynizK5MQZJrQ+s/MdrHz9lSSGSCufIbAdUgWpHM4NNpRg0GsDJHZyMCbihEt2rygLMbfnMvogBPt7d2JZsYFnUo0nO2y5885lvfjoGlwnvGrMyv7kolFNOpKIUxjU4OBd1VDV/vlXwHG78YvxsKBS/IBSbhSac4nJojFd9gRtIReHQqCqc85q7X6gOtEuj3zYsQrXRTPjsvV3+LctALMC+uONHOhxZqgkERzbPlZptrsbUe755j8hbOYcuhMEER87bV+MdWf9esSKKDxF3qzO1UULw2eSDja8O1RTZcKeM8UiFlzUP7OUijCP1MHaJMnyY2JhCsLZiuW7ZwgtMHPL9R1L5hJR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/05/25 at 12:03pm, Heiko Carstens wrote:
> On Fri, Dec 05, 2025 at 03:14:43PM +0800, Baoquan He wrote:
> > On 12/04/25 at 05:38pm, Andrey Konovalov wrote:
> > > On Fri, Nov 28, 2025 at 4:33 AM Baoquan He <bhe@redhat.com> wrote:
> > > I also wonder if we should keep this kasan=off functionality
> > > conservative and limit it to x86 and arm64 (since these are the only
> > > two tested architectures).
> > 
> > We may not need to do that. I tested on arm64 because it has sw_tags and
> > hw_tags. And if x86_64 and arm64 works well with kasan=off in generic
> > mode, it should be fine on other architectures. I am a little more
> > familiar with operations on x86/arm64 than others.  I can manage to get
> > power system to test kasan=off in generic mode, if that is required.
> > From my side, I would like to see x86_64/arm64/s390/power to have
> > kasan=off because RHEL support these architectures. I need consult people
> > to make clear how to change in s390. Will post patch later or ask other
> > people to help do that.
> 
> We are aware that s390 support is missing / does not work, and will
> provide something. I guess something based on this series would be
> good, or are you planning to send a new version anytime soon?

I will send v5 soon to address Andrey's concerns. That would be great if
you or any s390 expert can send patch based on v5. Thanks a lot.


