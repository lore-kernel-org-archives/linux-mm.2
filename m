Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE856EDEBEF
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 20:05:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C3036B0005; Tue,  3 Mar 2026 15:05:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 270376B008A; Tue,  3 Mar 2026 15:05:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17BEC6B008C; Tue,  3 Mar 2026 15:05:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0795E6B0005
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 15:05:00 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 87C148B05C
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 20:04:59 +0000 (UTC)
X-FDA: 84505830318.20.3C30B56
Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	by imf09.hostedemail.com (Postfix) with ESMTP id B258C14000C
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 20:04:57 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ALQfzfsv;
	spf=pass (imf09.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.50 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772568297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fz+KY6uKkd+TFMj791GXA5EfreSXyJZk4nTlfifWkf8=;
	b=DorQq2Lh01sg2cxXrCLtTuw1CcdXK1dEZUeAHFUzZIALjJat8Ko2I6lQhU4Xtxw3dNeZuF
	fp9cada8rR1b5sey0o6gfK+HPy4t2stWncXe+vk48MgZ5L/hT9m7Lwyel9bQHfUXA33sbl
	jc79Nl1LEww4MaYfokGvcCFpqWwhPZc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ALQfzfsv;
	spf=pass (imf09.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.50 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772568297; a=rsa-sha256;
	cv=none;
	b=tzhWxFB0i+UhAwgKZMaIQUrZLlIaz6/qA4AcWVPrzsprIkBogHA71o5xFJCXtdrfFHs9Ek
	Euw3r0rnT5EWa1S/8AMb4cdYEz5j9CIay8g7Yawv+a71nxzo/HpxJZtiRACTVm0QXqszaJ
	9YAiGZg0J6kRI1x+BwVeAAmPPS/3++A=
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-1270adc5121so7657660c88.0
        for <linux-mm@kvack.org>; Tue, 03 Mar 2026 12:04:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772568296; x=1773173096; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Fz+KY6uKkd+TFMj791GXA5EfreSXyJZk4nTlfifWkf8=;
        b=ALQfzfsvqvPSErrq61EbuLCl9FZOAE/T+r3FqqocODPGpq6HrGjfHtbAJ+otHlS4SV
         OuNtVelCVQOySdAM0f+pWkFJuW2TxizDgmBEKEyS7U/Bc3nq1J0N+gAwh2IwwiXItx/J
         s8zUUXGyvGtF2epLk0Si504YDFUNk//IUtEQgMQEz6G70fvqLwYsDMiurGziCI2mbg3B
         T6+7nRuiauwrNoIEdQuSko2dExkiRFks+FbsBPoRf5sjKpDiY+3mrXCQb8i+hc8fifGe
         eVxhfKFuM+XzgdalVQ754L80aWzcor6ngqEh9F4e6ShUL9KfXIls5tNZ8K1uJ88O9Jp3
         wlkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772568296; x=1773173096;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Fz+KY6uKkd+TFMj791GXA5EfreSXyJZk4nTlfifWkf8=;
        b=FSJVKpOBUofJVNWrrKbNTenjgiWzrFAy3SK9a0fPuH0bzdTbQEolBpW+f/XxnwVmbr
         GN6/8pDh6EhlRvKdr3iVN0J58OXf7h52O2NqQ2Fdg7fDn3dHr12NwDH3mflISn/CRiAN
         luT2V48HU6qGq1upGGpj1oXRPzZ0T116Zn4f2u4w4lkQS/X3HfsOqx9COp7A/R3edCDv
         H1GtEfeNx/LrnSqFUQ6KPo9GSy+wVpBUDBs34F1tQ2rE9UxGG4WU8YCgBnCEjPSeVoWs
         fqLQv+XJYmnKDB9i5RO8BePV9Gz2Xa/c1ShcKJLGtM8c/mLNXM8EDPn49PCN+OOHZx04
         /7TA==
X-Gm-Message-State: AOJu0YyB0qWJLdxazkf0mmJlI29+reQf3nkNEWg5n/mYl1CqY1QwG78C
	idfSiCt5W9EcE8W8nAPwXLAnko1rvwIzQqMQM8fATGs61bTAgSJNIKsz
X-Gm-Gg: ATEYQzxQdXvbVoTmubK5RK/OHwyAWdC+mn0aT24vntqQbIfOR8eq7sG6gtweHIM6gSu
	ywcR/9sD6e5cT/HcMH5rDhSUkz7PfBB/W37w3iOW9TRTP1qKPexRebrMpyTr8bum25M3I0eDSqc
	W7eIJ08dqS/x8YxyLIXLrvT61dzGUYE1hUpMx94e7fdSDmSya3wP6el0imBF/1GxFLKL54eCVYi
	/jQJb8jD5+QBf/XSGJgvIULKQ+FvRENO60G8CBtzbA1n0lQTnAB9eG2Fk4trWsiuJJryveqSfpJ
	y12SX0ArYx6g1yKwW6ZmJVzIc6CfH0eOgSUknoQTtRc5N+73FqcAaYNoqR6TR880AP67aK6ZYtp
	eTR9FsErVOt8AOr8OAZEVC9L34LDMIFAvx/E6Lf/rnK9F3lt2HRs+VQw0PRzC5e6LnkDbRcWx1y
	BQRL/6m4W7+tu29rqxKE5LQ7NzDF7bKBcA7GClCaHDA4bmb15Tpk14Wc7je5Z7vzaI3Mxf/62tC
	mpaMPpYfwJcI7I=
X-Received: by 2002:a05:7022:4591:b0:123:2d9d:a90d with SMTP id a92af1059eb24-1278fc21264mr5538380c88.17.1772568296176;
        Tue, 03 Mar 2026 12:04:56 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-127899eab46sm17006945c88.8.2026.03.03.12.04.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2026 12:04:55 -0800 (PST)
Date: Tue, 3 Mar 2026 12:04:53 -0800
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@suse.com>,
	Mikulas Patocka <mpatocka@redhat.com>, Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm/vmalloc: Fix incorrect size reporting on allocation
 failure
Message-ID: <aac-5Y9hlRwygHUN@fedora>
References: <20260302114740.2668450-1-urezki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302114740.2668450-1-urezki@gmail.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B258C14000C
X-Stat-Signature: odjsu4hcecje6613jqo5ugqfy56gp3du
X-Rspam-User: 
X-HE-Tag: 1772568297-435163
X-HE-Meta: U2FsdGVkX1+ozQp7zmra5rGlXbv+Zu7jQabZvV/axISrccDcTX9XTYaAxKjpUWFlwHva/5S2ifSUfH6iQNJQQw5CjAnDkpzrcjmeVvQJOoWon6M1Wgdo4cmeYME9Q/ADDKeWXkpfEcj+NOMFDQ5EZbQAOsQsLIhxsv+njGswFZOu1bDu5UyFZgGKmk/oI3J4Xh0ybWvMGFNl7Oq3Pt1yLz6GVmkyTpSfRWBEtwPW36zbiaRnjnrezxZHS0VwHtAc/cMEDyOm7R5f47KTbqSjd5ft0T3OEoHfGDk+2URXUf6aYTqsKqIlPMk4V6W6aGYAbw26Nhp+SZQoKjlXt08CIvw4nFd0rpHtpxjmTpeGhoGRfETMj0KIqN5FUO3ik/FXnEbr9hvlve6VgGZnHjMQO6yysGzF1pmFUQ4kVFb3N9tQuOGExTOe7/fuXWehi9RVOMafVmQIxWRVb35vOSImBHactqyQqYJBJFnQ8m2RnWPdmMefSc7aY/fsz2/uChPvTi304DyF8fEHl7CV2607mMsiSKC77tbK19ivFGHR59Firos5GFPfBzUPpusEQ8+O5v+GlaErK/1Gxb0mniGuX9qCzVbS5ubo6twbbt64duxo1trfQ3n0gn0Pk9nLKqX6GyLWjAz8lQlZtZHjuE5QWr2tKzZRKrC0Ok2dZoxNNH5s1+0Na2SWeprSfGpBDJnfs6v9F8mqCpPH0Nhq8aBuw8NwENuHAWiY+u3G7AYoSKfzU6pB888LuIweKS/Q7bSWNqBV8whrkQ+v+ieAaL7QM671qyez2fqqZzaElppfjdClA7JD9KAI3mESH0m2U9ijYgWHO/A2fhKgpvyVfUoVOtAv2jIbpzSK82vF62KsO9CCPSvl1NSHXWlR988z7WwtfsWlKrognWEwFYSmRcYkoMIhIt5BuEQau42ELQ3uw+LHJQOuK4vvnk7IVTSK26bWCQJpbc1xuPymtRLyyNI
 LnBgTfSr
 fYqMiEsBxHSkqaZKpSIuKWptnJC9sWuyV+41U5c0b6plhqqBY8n6tqC8rQzzYfUHNj/burwzOT1/7eslBetRp6bFJJ/X/ocbtaorHo/FmSPMpa5ZPi4WAsW92AMpBtmDArXaqdanbIJa1/gSC9gml2GNNylESSgowJ37P3xQtuBCkQqwEUPWxFO5FnM4DmfWMERQ3eDRQBTWlYIxYy9k1HD7LDPI/RbCoq8e6RyNon5Ab06uloTEj9CsLeVz8y9ApC1aL0s6ROrKMU4DkvZrt0jJtsGppy73JE2f9dbYRFf7JFHKNObbB8wZqLj103EZeqTba7EZbaJu/NnIZ9SlsBeaaTeyN7/2ZbNXPIQEiIOJpWaBKBhOuaPXWeO94RrRRpFK5bmUJvDSKDM2u2xh1jC3nNdsYut31FSWZKucSPxTkKxnWsjTnihnlSdbwUJcJ2MHq/y3XujQ06u9wx+UWg7DBpJkeSqP/tJRbV7vAp40ZWyfp7O2ZrFzWiRoWcFtvtbuF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 02, 2026 at 12:47:39PM +0100, Uladzislau Rezki (Sony) wrote:
> When __vmalloc_area_node() fails to allocate pages, the failure
> message may report an incorrect allocation size, for example:
> 
>   vmalloc error: size 0, failed to allocate pages, ...
> 
> This happens because the warning prints area->nr_pages * PAGE_SIZE.
> At this point, area->nr_pages may be zero or partly populated thus
> it is not valid.
> 
> Report the originally requested allocation size instead by using
> nr_small_pages * PAGE_SIZE, which reflects the actual number of
> pages being requested by user.
> 
> Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>

